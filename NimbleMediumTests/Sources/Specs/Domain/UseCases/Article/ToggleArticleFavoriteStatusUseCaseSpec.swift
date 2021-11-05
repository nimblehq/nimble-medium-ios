//
//  ToggleArticleFavoriteStatusUseCaseSpec.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 27/10/2021.
//

import Nimble
import Quick
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class ToggleArticleFavoriteStatusUseCaseSpec: QuickSpec {

    override func spec() {
        var usecase: ToggleArticleFavoriteStatusUseCase!
        var articleRepository: ArticleRepositoryProtocolMock!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a ToggleArticleFavoriteStatusUseCase") {

            beforeEach {
                disposeBag = DisposeBag()
                articleRepository = ArticleRepositoryProtocolMock()
                usecase = ToggleArticleFavoriteStatusUseCase(articleRepository: articleRepository)
                scheduler = TestScheduler(initialClock: 0)
            }

            describe("its execute() call") {

                let inputArticle = APIArticleResponse.dummy.article

                context("when isFavorite flag is true") {

                    context("when articleRepository.favoriteArticle() returns success") {

                        var outputCompleted: TestableObserver<Bool>!

                        beforeEach {
                            outputCompleted = scheduler.createObserver(Bool.self)
                            articleRepository.favoriteArticleSlugReturnValue = .just(inputArticle)

                            usecase.execute(slug: "", isFavorite: true)
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

                    context("when articleRepository.favoriteArticle() returns failure") {

                        var outputError: TestableObserver<Error?>!

                        beforeEach {
                            outputError = scheduler.createObserver(Error?.self)
                            articleRepository.favoriteArticleSlugReturnValue =
                                .error(TestError.mock)

                            usecase.execute(slug: "", isFavorite: true)
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

                context("when isFavorite flag is false") {

                    context("when articleRepository.unfavoriteArticle() returns success") {

                        var outputCompleted: TestableObserver<Bool>!

                        beforeEach {
                            outputCompleted = scheduler.createObserver(Bool.self)
                            articleRepository.unfavoriteArticleSlugReturnValue = .just(inputArticle)

                            usecase.execute(slug: "", isFavorite: false)
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

                    context("when articleRepository.unfavoriteArticle() returns failure") {

                        var outputError: TestableObserver<Error?>!

                        beforeEach {
                            outputError = scheduler.createObserver(Error?.self)
                            articleRepository.unfavoriteArticleSlugReturnValue =
                                .error(TestError.mock)

                            usecase.execute(slug: "", isFavorite: false)
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
}
