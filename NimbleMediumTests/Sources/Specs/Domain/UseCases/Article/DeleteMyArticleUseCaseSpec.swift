//
//  DeleteMyArticleUseCaseSpec.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 25/10/2021.
//

import Quick
import Nimble
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class DeleteMyArticleUseCaseSpec: QuickSpec {

    override func spec() {
        var usecase: DeleteMyArticleUseCase!
        var articleRepository: ArticleRepositoryProtocolMock!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("an DeleteMyArticleUseCase") {

            beforeEach {
                disposeBag = DisposeBag()
                articleRepository = ArticleRepositoryProtocolMock()
                usecase = DeleteMyArticleUseCase(articleRepository: articleRepository)
                scheduler = TestScheduler(initialClock: 0)
            }

            describe("its execute() call") {

                context("when articleRepository.deleteArticle() returns success") {

                    var outputCompleted: TestableObserver<Bool>!

                    beforeEach {
                        outputCompleted = scheduler.createObserver(Bool.self)
                        articleRepository.deleteArticleSlugReturnValue =
                            .empty()

                        usecase.execute(slug: "")
                            .asObservable()
                            .materialize()
                            .map { $0.isCompleted }
                            .bind(to: outputCompleted)
                            .disposed(by: disposeBag)
                    }

                    it("returns completed delete my article event") {
                        expect(outputCompleted.events.first?.value.element) == true
                    }
                }

                context("when articleRepository.deleteArticle() returns failure") {

                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Optional<Error>.self)
                        articleRepository.deleteArticleSlugReturnValue =
                            .error(TestError.mock)

                        usecase.execute(slug: "")
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
