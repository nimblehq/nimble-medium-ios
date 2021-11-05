//
//  UpdateMyArticleUseCaseSpec.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 26/10/2021.
//

import Nimble
import Quick
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class UpdateMyArticleUseCaseSpec: QuickSpec {

    override func spec() {
        var usecase: UpdateMyArticleUseCase!
        var articleRepository: ArticleRepositoryProtocolMock!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a UpdateMyArticleUseCase") {

            beforeEach {
                disposeBag = DisposeBag()
                articleRepository = ArticleRepositoryProtocolMock()
                usecase = UpdateMyArticleUseCase(articleRepository: articleRepository)
                scheduler = TestScheduler(initialClock: 0)
            }

            describe("its execute() call") {

                let inputArticle = APIArticleResponse.dummy.article

                context("when articleRepository.updateArticle() returns success") {

                    var outputCompleted: TestableObserver<Bool>!

                    beforeEach {
                        outputCompleted = scheduler.createObserver(Bool.self)
                        articleRepository.updateArticleSlugParamsReturnValue = .just(inputArticle)

                        usecase.execute(slug: "", params: UpdateMyArticleParameters.dummy)
                            .asObservable()
                            .materialize()
                            .map { $0.isCompleted }
                            .bind(to: outputCompleted)
                            .disposed(by: disposeBag)
                    }

                    it("returns completed update my article event") {
                        expect(outputCompleted.events.first?.value.element) == true
                    }
                }

                context("when articleRepository.updateArticle() returns failure") {

                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Error?.self)
                        articleRepository.updateArticleSlugParamsReturnValue =
                            .error(TestError.mock)

                        usecase.execute(slug: "", params: UpdateMyArticleParameters.dummy)
                            .asObservable()
                            .materialize()
                            .map { $0.error }
                            .bind(to: outputError)
                            .disposed(by: disposeBag)
                    }

                    it("returns an error") {
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
