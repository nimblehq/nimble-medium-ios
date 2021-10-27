//
//  ArticleRepositorySpec.swift
//  NimbleMediumTests
//
//  Created by Mark G on 06/09/2021.
//

import Nimble
import Quick
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class ArticleRepositorySpec: QuickSpec {

    override func spec() {
        var repository: ArticleRepository!
        var authenticatedNetworkAPI: AuthenticatedNetworkAPIProtocolMock!
        var networkAPI: NetworkAPIProtocolMock!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("an ArticleRepository") {

            beforeEach {
                disposeBag = DisposeBag()
                networkAPI = NetworkAPIProtocolMock()
                authenticatedNetworkAPI = AuthenticatedNetworkAPIProtocolMock()
                repository = ArticleRepository(
                    authenticatedNetworkAPI: authenticatedNetworkAPI,
                    networkAPI: networkAPI
                )
                scheduler = TestScheduler(initialClock: 0)
            }

            describe("its createArticle() call") {

                context("when the request returns success") {

                    var outputArticle: TestableObserver<DecodableArticle>!
                    let inputResponse = APIArticleResponse.dummy

                    beforeEach {
                        outputArticle = scheduler.createObserver(DecodableArticle.self)
                        authenticatedNetworkAPI.setPerformRequestForReturnValue(Single.just(inputResponse))
                        repository.createArticle(params: CreateArticleParameters.dummy)
                            .asObservable()
                            .compactMap { $0 as? DecodableArticle }
                            .bind(to: outputArticle)
                            .disposed(by: disposeBag)
                    }

                    it("returns correct article") {
                        expect(outputArticle.events.first?.value.element) == inputResponse.article
                    }
                }

                context("when the request returns failure") {

                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Error?.self)
                        authenticatedNetworkAPI.setPerformRequestForReturnValue(
                            Single<APIArticleResponse>.error(TestError.mock)
                        )
                        repository.createArticle(params: CreateArticleParameters.dummy)
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

            describe("its deleteArticle() call") {

                context("when the request returns success") {

                    var outputCompleted: TestableObserver<Bool>!

                    beforeEach {
                        outputCompleted = scheduler.createObserver(Bool.self)
                        authenticatedNetworkAPI.performRequestReturnValue = .empty()
                        repository.deleteArticle(slug: "")
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

                context("when the request returns failure") {

                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Error?.self)
                        authenticatedNetworkAPI.performRequestReturnValue = .error(TestError.mock)
                        repository.deleteArticle(slug: "")
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

            describe("its getArticle() call") {

                context("when the request returns success") {

                    var outputArticle: TestableObserver<DecodableArticle>!
                    let inputResponse = APIArticleResponse.dummy

                    beforeEach {
                        outputArticle = scheduler.createObserver(DecodableArticle.self)
                        networkAPI.setPerformRequestForReturnValue(Single.just(inputResponse))
                        repository.getArticle(slug: "slug")
                            .asObservable()
                            .compactMap {
                                $0 as? DecodableArticle
                            }
                            .bind(to: outputArticle)
                            .disposed(by: disposeBag)
                    }

                    it("returns correct article") {
                        expect(outputArticle.events.first?.value.element) == inputResponse.article
                    }
                }

                context("when the request returns failure") {

                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Error?.self)
                        networkAPI.setPerformRequestForReturnValue(Single<APIArticleResponse>.error(TestError.mock))
                        repository.getArticle(slug: "slug")
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

            describe("its listArticles() call") {

                context("when the request returns success") {

                    var outputArticles: TestableObserver<[DecodableArticle]>!
                    let inputResponse = APIArticlesResponse.dummy

                    beforeEach {
                        outputArticles = scheduler.createObserver([DecodableArticle].self)
                        networkAPI.setPerformRequestForReturnValue(Single.just(inputResponse))
                        repository.listArticles(params: .init())
                            .asObservable()
                            .map { $0.compactMap { $0 as? DecodableArticle } }
                            .bind(to: outputArticles)
                            .disposed(by: disposeBag)
                    }

                    it("returns correct articles") {
                        expect(outputArticles.events) == [
                            .next(0, inputResponse.articles),
                            .completed(0)
                        ]
                    }
                }

                context("when the request returns failure") {

                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Error?.self)
                        networkAPI.setPerformRequestForReturnValue(Single<APIArticlesResponse>.error(TestError.mock))
                        repository.listArticles(params: .init())
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

            describe("its updateArticle() call") {

                context("when the request returns success") {

                    var outputArticle: TestableObserver<DecodableArticle>!
                    let inputResponse = APIArticleResponse.dummy

                    beforeEach {
                        outputArticle = scheduler.createObserver(DecodableArticle.self)
                        authenticatedNetworkAPI.setPerformRequestForReturnValue(Single.just(inputResponse))
                        repository.updateArticle(slug: "", params: UpdateMyArticleParameters.dummy)
                            .asObservable()
                            .compactMap { $0 as? DecodableArticle }
                            .bind(to: outputArticle)
                            .disposed(by: disposeBag)
                    }

                    it("returns the correctly updated article") {
                        expect(outputArticle.events.first?.value.element) == inputResponse.article
                    }
                }

                context("when the request returns failure") {

                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Error?.self)
                        authenticatedNetworkAPI.setPerformRequestForReturnValue(
                            Single<APIArticleResponse>.error(TestError.mock)
                        )
                        repository.updateArticle(slug: "", params: UpdateMyArticleParameters.dummy)
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
