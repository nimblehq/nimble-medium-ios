//
//  GetCurrentUserFollowingArticlesUseCaseSpec.swift
//  NimbleMediumTests
//
//  Created by Mark G on 08/09/2021.
//

import Quick
import Nimble
import RxNimble
import RxSwift
import RxTest
import Resolver

@testable import NimbleMedium

// swiftlint:disable type_name
final class GetCurrentUserFollowingArticlesUseCaseSpec: QuickSpec {

    @LazyInjected var articleRepository: ArticleRepositoryProtocolMock
    @LazyInjected var getCurrentSessionUseCase: GetCurrentSessionUseCaseProtocolMock

    override func spec() {
        var useCase: GetCurrentUserFollowingArticlesUseCase!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("an GetCurrentUserFollowingArticlesUseCase") {

            beforeEach {
                Resolver.registerMockServices()
                disposeBag = DisposeBag()
                useCase = GetCurrentUserFollowingArticlesUseCase(
                    articleRepository: self.articleRepository,
                    getCurrentSessionUseCase: self.getCurrentSessionUseCase
                )
                scheduler = TestScheduler(initialClock: 0)
            }

            describe("its execute() call") {

                context("when GetCurrentSessionUseCase returns empty") {
                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Optional<Error>.self)
                        self.getCurrentSessionUseCase.executeReturnValue = .just(nil)

                        useCase.execute(
                            limit: nil,
                            offset: nil
                        )
                            .asObservable()
                            .materialize()
                            .map { $0.error }
                            .bind(to: outputError)
                            .disposed(by: disposeBag)
                    }

                    it("returns generic error") {
                        let error = outputError.events.first?.value.element as? NetworkAPIError
                        expect(error) == .generic
                    }
                }

                context("when GetCurrentSessionUseCase returns valid user") {
                    let user = APIUserResponse.dummy.user

                    beforeEach {
                        self.getCurrentSessionUseCase.executeReturnValue = .just(user)
                    }

                    context("when articleRepository.listArticles() returns success") {

                        let inputArticles = APIArticlesResponse.dummy.articles

                        var outputArticles: TestableObserver<[DecodableArticle]>!

                        beforeEach {
                            outputArticles = scheduler.createObserver([DecodableArticle].self)
                            self.articleRepository
                                .listArticlesTagAuthorFavoritedLimitOffsetReturnValue = .just(inputArticles)

                            useCase.execute(
                                limit: nil,
                                offset: nil
                            )
                                .asObservable()
                                .map {
                                    $0.compactMap { $0 as? DecodableArticle }
                                }
                                .bind(to: outputArticles)
                                .disposed(by: disposeBag)
                        }

                        it("returns correct articles") {
                            expect(outputArticles.events.first?.value.element) == inputArticles
                        }
                    }

                    context("when articleRepository.listArticles() returns failure") {

                        var outputError: TestableObserver<Error?>!

                        beforeEach {
                            outputError = scheduler.createObserver(Optional<Error>.self)
                            self.articleRepository
                                .listArticlesTagAuthorFavoritedLimitOffsetReturnValue = .error(TestError.mock)

                            useCase.execute(
                                limit: nil,
                                offset: nil
                            )
                                .asObservable()
                                .materialize()
                                .map { $0.error }
                                .bind(to: outputError)
                                .disposed(by: disposeBag)
                        }

                        it("returns correct error") {
                            let error = outputError.events.first?.value.element as? TestError
                            expect(error) == TestError.mock
                        }
                    }

                }

                context("when GetCurrentSessionUseCase returns failure") {
                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Optional<Error>.self)
                        self.getCurrentSessionUseCase.executeReturnValue = .error(TestError.mock)

                        useCase.execute(
                            limit: nil,
                            offset: nil
                        )
                            .asObservable()
                            .materialize()
                            .map { $0.error }
                            .bind(to: outputError)
                            .disposed(by: disposeBag)
                    }

                    it("returns correct error") {
                        let error = outputError.events.first?.value.element as? TestError
                        expect(error) == TestError.mock
                    }
                }
            }
        }
    }
}
