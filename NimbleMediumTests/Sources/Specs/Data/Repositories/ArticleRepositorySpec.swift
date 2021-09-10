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
                    let inputResponse = APIArticleResponse.dummy

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
                        .map {
                            $0.compactMap { $0 as? DecodableArticle }
                        }
                        .bind(to: outputArticles)
                        .disposed(by: disposeBag)
                    }

                    it("returns correct articles") {
                        expect(outputArticles.events.first?.value.element) == inputResponse.articles
                    }
                }

                context("when the request returns failure") {

                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Optional<Error>.self)
                        networkAPI.setPerformRequestForReturnValue(Single<APIArticleResponse>.error(TestError.mock))
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
                        expect(error) == TestError.mock
                    }
                }
            }
        }
    }
}