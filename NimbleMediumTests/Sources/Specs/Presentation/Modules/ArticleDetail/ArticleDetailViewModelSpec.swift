//
//  FeedDetailViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Mark G on 15/09/2021.
//

import Nimble
import Quick
import Resolver
import RxCocoa
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class ArticleDetailViewModelSpec: QuickSpec {

    @LazyInjected var getArticleUseCase: GetArticleUseCaseProtocolMock
    @LazyInjected var followUserUseCase: FollowUserUseCaseProtocolMock
    @LazyInjected var unfollowUserUseCase: UnfollowUserUseCaseProtocolMock
    @LazyInjected var deleteArticleUseCase: DeleteMyArticleUseCaseProtocolMock
    @LazyInjected var getCurrentSessionUseCase: GetCurrentSessionUseCaseProtocolMock
    @LazyInjected var toggleArticleFavoriteStatusUseCase: ToggleArticleFavoriteStatusUseCaseProtocolMock

    override func spec() {
        var viewModel: ArticleDetailViewModelProtocol!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a ArticleDetailViewModel") {

            beforeEach {
                Resolver.registerMockServices()
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
            }

            describe("its fetchArticle() call") {

                beforeEach {
                    SharingScheduler.mock(scheduler: scheduler) {
                        viewModel = ArticleDetailViewModel(id: "slug")
                    }
                }

                context("when GetArticleUseCase return success") {
                    let inputArticle = APIArticleResponse.dummy.article

                    beforeEach {
                        self.getCurrentSessionUseCase.executeReturnValue = .just(nil, on: scheduler, at: 15)
                        self.getArticleUseCase.executeSlugReturnValue = .just(inputArticle, on: scheduler, at: 10)

                        scheduler.scheduleAt(5) {
                            viewModel.input.fetchArticleDetail()
                        }
                    }

                    it("returns output uiModel with correct value") {
                        expect(viewModel.output.uiModel)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(1, nil),
                                .next(11, .init(article: inputArticle))
                            ]
                    }
                }

                context("when GetCurrentSessionUseCase return a user is the author") {
                    let inputArticle = APIArticleResponse.dummy.article
                    let inputUser = APIUserResponse.dummy(with: inputArticle.author.username).user

                    beforeEach {
                        self.getArticleUseCase.executeSlugReturnValue = .just(inputArticle, on: scheduler, at: 10)
                        self.getCurrentSessionUseCase.executeReturnValue = .just(inputUser)

                        scheduler.scheduleAt(5) {
                            viewModel.input.fetchArticleDetail()
                        }
                    }

                    it("returns output isArticleAuthor with correct value") {
                        expect(viewModel.output.isArticleAuthor)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(1, false),
                                .next(11, true)
                            ]
                    }
                }

                context("when GetCurrentSessionUseCase return a user is not the author") {
                    let inputArticle = APIArticleResponse.dummy.article
                    let inputUser = APIUserResponse.dummy(with: "\(inputArticle.author.username)x").user

                    beforeEach {
                        self.getArticleUseCase.executeSlugReturnValue = .just(inputArticle, on: scheduler, at: 10)
                        self.getCurrentSessionUseCase.executeReturnValue = .just(inputUser)

                        scheduler.scheduleAt(5) {
                            viewModel.input.fetchArticleDetail()
                        }
                    }

                    it("returns output isArticleAuthor with correct value") {
                        expect(viewModel.output.isArticleAuthor)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(1, false),
                                .next(11, false)
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

                beforeEach {
                    SharingScheduler.mock(scheduler: scheduler) {
                        viewModel = ArticleDetailViewModel(id: "slug")
                    }
                }

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
                                    .map { $0?.authorIsFollowing }
                            )
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(1, nil),
                                .next(11, false),
                                .next(16, true)
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
                                    .map { $0?.authorIsFollowing }
                            )
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(1, nil),
                                .next(11, false),
                                .next(16, true),
                                .next(21, false)
                            ]
                        }
                    }
                }
            }

            describe("its deleteArticle() call") {

                beforeEach {
                    viewModel = ArticleDetailViewModel(id: "slug")
                }

                context("when DeleteArticleUseCase return success") {

                    beforeEach {
                        self.deleteArticleUseCase.executeSlugReturnValue = .empty(on: scheduler, at: 10)

                        scheduler.scheduleAt(5) {
                            viewModel.input.deleteArticle()
                        }
                    }

                    it("returns output didDeleteArticle with signal") {
                        expect(viewModel.output.didDeleteArticle)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }

                    it("returns output isLoading with correct value") {
                        expect(viewModel.output.isLoading)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(0, false),
                                .next(5, true),
                                .next(10, false)
                            ]
                    }
                }

                context("when DeleteArticleUseCase return failure") {

                    beforeEach {
                        self.deleteArticleUseCase.executeSlugReturnValue = .error(TestError.mock, on: scheduler, at: 10)

                        scheduler.scheduleAt(5) {
                            viewModel.input.deleteArticle()
                        }
                    }

                    it("returns output didFailToFetchArticleDetail with signal") {
                        expect(viewModel.output.didFailToDeleteArticle)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }

                    it("returns output isLoading with correct value") {
                        expect(viewModel.output.isLoading)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(0, false),
                                .next(5, true),
                                .next(10, false)
                            ]
                    }
                }
            }

            describe("its toggleFollowUser() call") {

                let inputArticle = APIArticleResponse.dummyWithUnfollowingUser.article

                beforeEach {
                    SharingScheduler.mock(scheduler: scheduler) {
                        viewModel = ArticleDetailViewModel(id: "slug")
                    }
                }

                context("when ToggleArticleFavoriteStatusUseCase return success") {

                    beforeEach {
                        self.getArticleUseCase.executeSlugReturnValue = .just(inputArticle, on: scheduler, at: 10)
                        self.toggleArticleFavoriteStatusUseCase
                            .executeSlugIsFavoriteReturnValue = .empty(on: scheduler, at: 20)

                        scheduler.scheduleAt(5) {
                            viewModel.input.fetchArticleDetail()
                        }

                        scheduler.scheduleAt(15) {
                            viewModel.input.toggleFavouriteArticle()
                        }
                    }

                    it("returns output uiModel with correct authorFollowing value") {
                        expect(
                            viewModel.output.uiModel
                                .map { $0?.articleIsFavorited }
                        )
                        .events(scheduler: scheduler, disposeBag: disposeBag) == [
                            .next(1, nil),
                            .next(11, inputArticle.favorited),
                            .next(16, !inputArticle.favorited)
                        ]
                    }
                }

                context("when ToggleArticleFavoriteStatusUseCase return failure") {

                    beforeEach {
                        self.getArticleUseCase.executeSlugReturnValue = .just(inputArticle, on: scheduler, at: 10)
                        self.toggleArticleFavoriteStatusUseCase.executeSlugIsFavoriteReturnValue = .error(
                            TestError.mock,
                            on: scheduler,
                            at: 20
                        )

                        scheduler.scheduleAt(5) {
                            viewModel.input.fetchArticleDetail()
                        }

                        scheduler.scheduleAt(15) {
                            viewModel.input.toggleFavouriteArticle()
                        }
                    }

                    it("returns output didFailToToggleFavouriteArticle with signal") {
                        expect(viewModel.output.didFailToToggleFavouriteArticle)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }

                    it("reverts articleIsFavorited value") {
                        expect(
                            viewModel.output.uiModel
                                .map { $0?.articleIsFavorited }
                        )
                        .events(scheduler: scheduler, disposeBag: disposeBag) == [
                            .next(1, nil),
                            .next(11, inputArticle.favorited),
                            .next(16, !inputArticle.favorited),
                            .next(21, inputArticle.favorited)
                        ]
                    }
                }
            }
        }
    }
}
