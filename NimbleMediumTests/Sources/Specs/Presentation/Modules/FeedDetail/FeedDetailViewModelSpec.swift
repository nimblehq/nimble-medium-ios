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

                    it("returns output feedDetailUIModel with correct value") {
                        expect(viewModel.output.feedDetailUIModel)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(0, nil),
                                .next(10, .init(article: inputArticle))
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
