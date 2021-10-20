//
//  CreateArticleUseCaseSpec.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 18/10/2021.
//

import Quick
import Nimble
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class CreateArticleUseCaseSpec: QuickSpec {

    override func spec() {
        var usecase: CreateArticleUseCase!
        var articleRepository: ArticleRepositoryProtocolMock!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("an CreateArticleUseCase") {

            beforeEach {
                disposeBag = DisposeBag()
                articleRepository = ArticleRepositoryProtocolMock()
                usecase = CreateArticleUseCase(articleRepository: articleRepository)
                scheduler = TestScheduler(initialClock: 0)
            }

            describe("its execute() call") {

                context("when articleRepository.createArticle() returns success") {

                    let inputArticle = APIArticleResponse.dummy.article
                    var outputArticle: TestableObserver<DecodableArticle>!

                    beforeEach {
                        outputArticle = scheduler.createObserver(DecodableArticle.self)
                        articleRepository.createArticleParamsReturnValue = .just(inputArticle)

                        usecase.execute(params: CreateArticleParameters.dummy)
                            .asObservable()
                            .compactMap { $0 as? DecodableArticle }
                            .bind(to: outputArticle)
                            .disposed(by: disposeBag)
                    }

                    it("returns correct article") {
                        expect(outputArticle.events) == [
                            .next(0, inputArticle),
                            .completed(0)
                        ]
                    }
                }

                context("when articleRepository.createArticle() returns failure") {

                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Optional<Error>.self)
                        articleRepository.createArticleParamsReturnValue = .error(TestError.mock)

                        usecase.execute(params: CreateArticleParameters.dummy)
                            .asObservable()
                            .materialize()
                            .map { $0.error }
                            .bind(to: outputError)
                            .disposed(by: disposeBag)
                    }

                    it("returns correct error") {
                        let error = outputError.events.first?.value.element as? TestError

                        expect(outputError.events.count) == 2
                        expect(error) == TestError.mock
                        expect(outputError.events.last?.value.isCompleted) == true
                    }
                }
            }
        }
    }
}
