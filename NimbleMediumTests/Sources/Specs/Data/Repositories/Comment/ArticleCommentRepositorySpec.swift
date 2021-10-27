//
//  ArticleCommentRepositorySpec.swift
//  NimbleMediumTests
//
//  Created by Mark G on 15/09/2021.
//

import Nimble
import Quick
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class ArticleCommentRepositorySpec: QuickSpec {

    override func spec() {
        var repository: ArticleCommentRepository!
        var authenticatedNetworkAPI: AuthenticatedNetworkAPIProtocolMock!
        var networkAPI: NetworkAPIProtocolMock!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("an ArticleCommentRepository") {

            beforeEach {
                disposeBag = DisposeBag()
                authenticatedNetworkAPI = AuthenticatedNetworkAPIProtocolMock()
                networkAPI = NetworkAPIProtocolMock()
                repository = ArticleCommentRepository(
                    authenticatedNetworkAPI: authenticatedNetworkAPI,
                    networkAPI: networkAPI
                )
                scheduler = TestScheduler(initialClock: 0)
            }

            describe("its createComment() call") {

                context("when the request returns success") {

                    var outputArticleComment: TestableObserver<APIArticleComment>!
                    let inputResponse = APIArticleCommentResponse.dummy

                    beforeEach {
                        outputArticleComment = scheduler.createObserver(APIArticleComment.self)
                        authenticatedNetworkAPI.setPerformRequestForReturnValue(Single.just(inputResponse))
                        repository.createComment(articleSlug: "", commentBody: "")
                            .asObservable()
                            .compactMap { $0 as? APIArticleComment }
                            .bind(to: outputArticleComment)
                            .disposed(by: disposeBag)
                    }

                    it("returns correct articles") {
                        expect(outputArticleComment).events() == [
                            .next(0, inputResponse.comment),
                            .completed(0)
                        ]
                    }
                }

                context("when the request returns failure") {

                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Error?.self)
                        authenticatedNetworkAPI.setPerformRequestForReturnValue(
                            Single<APIArticleCommentResponse>.error(TestError.mock)
                        )
                        repository.createComment(articleSlug: "", commentBody: "")
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
                        outputError = scheduler.createObserver(Error?.self)
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
