//
//  ArticleCommentRepositorySpec.swift
//  NimbleMediumTests
//
//  Created by Mark G on 15/09/2021.
//

import Quick
import Nimble
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class ArticleCommentRepositorySpec: QuickSpec {

    override func spec() {
        var repository: ArticleCommentRepository!
        var networkAPI: NetworkAPIProtocolMock!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("an ArticleCommentRepository") {

            beforeEach {
                disposeBag = DisposeBag()
                networkAPI = NetworkAPIProtocolMock()
                repository = ArticleCommentRepository(networkAPI: networkAPI)
                scheduler = TestScheduler(initialClock: 0)
            }

            describe("its getComments() call") {

                context("when the request returns success") {

                    var outputArticleComments: TestableObserver<[APIArticleComment]>!
                    let inputResponse = APIArticleCommentsResponse.dummy

                    beforeEach {
                        outputArticleComments = scheduler.createObserver([APIArticleComment].self)
                        networkAPI.setPerformRequestForReturnValue(Single.just(inputResponse))
                        repository.getComments(slug: "")
                            .asObservable()
                            .map { $0.compactMap { $0 as? APIArticleComment } }
                            .bind(to: outputArticleComments)
                            .disposed(by: disposeBag)
                    }

                    it("returns correct articles") {
                        expect(outputArticleComments).events() == [
                            .next(0, inputResponse.comments),
                            .completed(0)
                        ]
                    }
                }

                context("when the request returns failure") {

                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Optional<Error>.self)
                        networkAPI.setPerformRequestForReturnValue(
                            Single<APIArticleCommentsResponse>.error(TestError.mock)
                        )
                        repository.getComments(slug: "")
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
