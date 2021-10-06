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
                            viewModel.input.fetch()
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
                            viewModel.input.fetch()
                        }
                    }

                    it("returns output didFailToFetch with signal") {
                        expect(viewModel.output.didFailToFetch)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }
                }
            }
        }
    }
}
