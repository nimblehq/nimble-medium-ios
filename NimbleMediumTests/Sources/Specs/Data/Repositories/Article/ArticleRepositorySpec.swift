//
//  ArticleRepositorySpec.swift
//  NimbleMediumTests
//
//  Created by Mark G on 06/09/2021.
//

import Quick
import Nimble
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class ArticleRepositorySpec: QuickSpec {

    override func spec() {
        var repository: ArticleRepository!
        var networkAPI: NetworkAPIProtocolMock!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("an ArticleRepository") {

            beforeEach {
                disposeBag = DisposeBag()
                networkAPI = NetworkAPIProtocolMock()
                repository = ArticleRepository(networkAPI: networkAPI)
                scheduler = TestScheduler(initialClock: 0)
            }

            describe("its listArticles() call") {

                context("when the request returns success") {
                    
                    var outputArticles: TestableObserver<[DecodableArticle]>!
                    let inputResponse = APIArticlesResponse.dummy

                    beforeEach {
                        outputArticles = scheduler.createObserver([DecodableArticle].self)
                        networkAPI.setPerformRequestForReturnValue(Single.just(inputResponse))
                        repository.listArticles(
                            tag: nil,
                            author: nil,
                            favorited: nil,
                            limit: nil,
                            offset: nil
                        )
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
                        outputError = scheduler.createObserver(Optional<Error>.self)
                        networkAPI.setPerformRequestForReturnValue(Single<APIArticlesResponse>.error(TestError.mock))
                        repository.listArticles(
                            tag: nil,
                            author: nil,
                            favorited: nil,
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
                        outputError = scheduler.createObserver(Optional<Error>.self)
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
        }
    }
}
