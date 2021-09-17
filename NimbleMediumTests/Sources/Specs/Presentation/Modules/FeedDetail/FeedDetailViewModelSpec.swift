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

final class FeedDetailViewModelSpec: QuickSpec {

    @LazyInjected var getArticleUseCase: GetArticleUseCaseProtocolMock
    
    override func spec() {
        var viewModel: FeedDetailViewModelProtocol!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a FeedDetailViewModel") {

            beforeEach {
                Resolver.registerMockServices()
                viewModel = FeedDetailViewModel(slug: "slug")
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
            }

            describe("its fetchArticle() call") {

                context("when GetArticleUseCase return success") {
                    let inputArticle = APIArticleResponse.dummy.article

                    beforeEach {
                        self.getArticleUseCase.getArticleSlugReturnValue = .just(inputArticle, on: scheduler, at: 10)

                        scheduler.scheduleAt(5) {
                            viewModel.input.fetchArticle()
                        }
                    }

                    it("returns output articleTitle with correct value") {
                        expect(viewModel.output.articleTitle)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(0, ""),
                                .next(10, inputArticle.title)
                            ]
                    }

                    it("returns output articleBody with correct value") {
                        expect(viewModel.output.articleBody)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(0, ""),
                                .next(10, inputArticle.body)
                            ]
                    }

                    it("returns output authorName with correct value") {
                        expect(viewModel.output.authorName)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(0, ""),
                                .next(10, inputArticle.author.username)
                            ]
                    }

                    it("returns output authorImage with correct value") {
                        expect(viewModel.output.authorImage)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(0, nil),
                                .next(10, try? inputArticle.author.image?.asURL())
                            ]
                    }

                    it("returns output articleUpdatedAt with correct value") {
                        expect(viewModel.output.articleUpdatedAt)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(0, ""),
                                .next(10, inputArticle.updatedAt.format(with: .monthDayYear))
                            ]
                    }
                }

                context("when GetArticleUseCase return failure") {

                    beforeEach {
                        self.getArticleUseCase.getArticleSlugReturnValue = .error(TestError.mock, on: scheduler, at: 10)

                        scheduler.scheduleAt(5) {
                            viewModel.input.fetchArticle()
                        }
                    }

                    it("returns output didFailToFetchArticle with signal") {
                        expect(viewModel.output.didFailToFetchArticle)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }
                }
            }
        }
    }
}
