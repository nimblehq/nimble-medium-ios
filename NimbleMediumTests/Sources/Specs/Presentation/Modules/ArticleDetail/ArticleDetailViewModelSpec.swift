//
//  FeedDetailViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Mark G on 15/09/2021.
//

import Quick
import Nimble
import RxNimble
import RxSwift
import RxTest
import Resolver

@testable import NimbleMedium

final class ArticleDetailViewModelSpec: QuickSpec {

    @LazyInjected var getArticleUseCase: GetArticleUseCaseProtocolMock
    @LazyInjected var followUserUseCase: FollowUserUseCaseProtocolMock
    @LazyInjected var unfollowUserUseCase: UnfollowUserUseCaseProtocolMock
    
    override func spec() {
        var viewModel: ArticleDetailViewModelProtocol!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a ArticleDetailViewModel") {

            beforeEach {
                Resolver.registerMockServices()
                viewModel = ArticleDetailViewModel(id: "slug")
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
            }

            describe("its fetchArticle() call") {

                context("when GetArticleUseCase return success") {
                    let inputArticle = APIArticleResponse.dummy.article

                    beforeEach {
                        self.getArticleUseCase.executeSlugReturnValue = .just(inputArticle, on: scheduler, at: 10)

                        scheduler.scheduleAt(5) {
                            viewModel.input.fetchArticleDetail()
                        }
                    }

                    it("returns output uiModel with correct value") {
                        expect(viewModel.output.uiModel)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(0, nil),
                                .next(10, .init(article: inputArticle))
                            ]
                    }
                }

                context("when GetArticleUseCase return failure") {

                    beforeEach {
                        self.getArticleUseCase.executeSlugReturnValue = .error(TestError.mock, on: scheduler, at: 10)

                        scheduler.scheduleAt(5) {
                            viewModel.input.fetchArticleDetail()
                        }
                    }

                    it("returns output didFailToFetchArticleDetail with signal") {
                        expect(viewModel.output.didFailToFetchArticleDetail)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }
                }
            }

            describe("its toggleFollowUser() call") {

                let inputArticle = APIArticleResponse.dummyWithUnfollowingUser.article

                context("when it toggles to follow") {

                    context("when FollowUserUseCase return success") {
                        
                        beforeEach {
                            self.getArticleUseCase.executeSlugReturnValue = .just(inputArticle, on: scheduler, at: 10)
                            self.followUserUseCase.executeUsernameReturnValue = .empty(on: scheduler, at: 20)

                            scheduler.scheduleAt(5) {
                                viewModel.input.fetchArticleDetail()
                            }

                            scheduler.scheduleAt(15) {
                                viewModel.input.toggleFollowUser()
                            }
                        }

                        it("returns output uiModel with correct authorFollowing value") {
                            expect(
                                viewModel.output.uiModel
                                    .map { $0?.authorFollowing }
                            )
                                .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                    .next(0, nil),
                                    .next(10, false),
                                    .next(15, true)
                                ]
                        }
                    }

                    context("when FollowUserUseCase return failure") {

                        beforeEach {
                            self.getArticleUseCase.executeSlugReturnValue = .just(inputArticle, on: scheduler, at: 10)
                            self.followUserUseCase.executeUsernameReturnValue = .error(
                                TestError.mock,
                                on: scheduler,
                                at: 20
                            )

                            scheduler.scheduleAt(5) {
                                viewModel.input.fetchArticleDetail()
                            }

                            scheduler.scheduleAt(15) {
                                viewModel.input.toggleFollowUser()
                            }
                        }

                        it("returns output didFailToToggleFollow with signal") {
                            expect(viewModel.output.didFailToToggleFollow)
                                .events(scheduler: scheduler, disposeBag: disposeBag)
                                .notTo(beEmpty())
                        }

                        it("reverts authorFollowing value") {
                            expect(
                                viewModel.output.uiModel
                                    .map { $0?.authorFollowing }
                            )
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(0, nil),
                                .next(10, false),
                                .next(15, true),
                                .next(20, false)
                            ]
                        }
                    }
                }
            }
        }
    }
}
