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
        var viewModel: FeedDetailViewModel!
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
                    var outputArticle: TestableObserver<DecodableArticle>!

                    beforeEach {
                        outputArticle = scheduler.createObserver(DecodableArticle.self)

                        self.getArticleUseCase.getArticleSlugReturnValue = .just(inputArticle)

                        viewModel.output.article
                            .asObservable()
                            .compactMap { $0 as? DecodableArticle }
                            .bind(to: outputArticle)
                            .disposed(by: disposeBag)

                        viewModel.fetchArticle()
                    }

                    it("returns output article with correct value") {
                        expect(outputArticle.events.last?.value.element) == inputArticle
                    }
                }

                context("when GetArticleUseCase return failure") {
                    var outputError: TestableObserver<Error>!

                    beforeEach {
                        outputError = scheduler.createObserver(Error.self)

                        self.getArticleUseCase.getArticleSlugReturnValue = .error(TestError.mock)

                        viewModel.output.didFailToFetchArticle
                            .asObservable()
                            .bind(to: outputError)
                            .disposed(by: disposeBag)

                        viewModel.fetchArticle()
                    }

                    it("returns output didFailToFetchArticle with correct error") {
                        let error = outputError.events.first?.value.element as? TestError
                        expect(error) == TestError.mock
                    }
                }
            }
        }
    }
}
