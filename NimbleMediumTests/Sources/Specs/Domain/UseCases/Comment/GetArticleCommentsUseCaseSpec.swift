//
//  GetArticleCommentsUseCaseSpec.swift
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

final class GetArticleCommentsUseCaseSpec: QuickSpec {

    override func spec() {
        var usecase: GetArticleCommentsUseCase!
        var articleCommentRepository: ArticleCommentRepositoryProtocolMock!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("an ArticleRepository") {

            beforeEach {
                disposeBag = DisposeBag()
                articleCommentRepository = ArticleCommentRepositoryProtocolMock()
                usecase = GetArticleCommentsUseCase(articleCommentRepository: articleCommentRepository)
                scheduler = TestScheduler(initialClock: 0)
            }

            describe("its getComments() call") {

                context("when articleCommentRepository.getComments() returns success") {

                    let inputArticleComments = APIArticleCommentsResponse.dummy.comments
                    var outputArticleComments: TestableObserver<[APIArticleComment]>!

                    beforeEach {
                        outputArticleComments = scheduler.createObserver([APIArticleComment].self)
                        articleCommentRepository.getCommentsSlugReturnValue = .just(inputArticleComments)

                        usecase.execute(slug: "")
                        .asObservable()
                        .map { $0.compactMap { $0 as? APIArticleComment } }
                        .bind(to: outputArticleComments)
                        .disposed(by: disposeBag)
                    }

                    it("returns correct article comments") {
                        expect(outputArticleComments.events.first?.value.element) == inputArticleComments
                    }
                }

                context("when articleCommentRepository.getComments() returns failure") {

                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Optional<Error>.self)
                        articleCommentRepository.getCommentsSlugReturnValue = .error(TestError.mock)

                        usecase.execute(slug: "")
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
