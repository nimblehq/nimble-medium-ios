//
//  CreateArticleCommentUseCaseSpec.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 19/10/2021.
//

import Nimble
import Quick
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class CreateArticleCommentUseCaseSpec: QuickSpec {

    override func spec() {
        var usecase: CreateArticleCommentUseCase!
        var articleCommentRepository: ArticleCommentRepositoryProtocolMock!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("an CreateArticleCommentUseCase") {

            beforeEach {
                disposeBag = DisposeBag()
                articleCommentRepository = ArticleCommentRepositoryProtocolMock()
                usecase = CreateArticleCommentUseCase(articleCommentRepository: articleCommentRepository)
                scheduler = TestScheduler(initialClock: 0)
            }

            describe("its execute() call") {

                context("when articleCommentRepository.createComment() returns success") {

                    let inputArticleComment = APIArticleCommentResponse.dummy.comment
                    var outputArticleComment: TestableObserver<APIArticleComment>!

                    beforeEach {
                        outputArticleComment = scheduler.createObserver(APIArticleComment.self)
                        articleCommentRepository.createCommentArticleSlugCommentBodyReturnValue =
                            .just(inputArticleComment)

                        usecase.execute(articleSlug: "", commentBody: "")
                            .asObservable()
                            .compactMap { $0 as? APIArticleComment }
                            .bind(to: outputArticleComment)
                            .disposed(by: disposeBag)
                    }

                    it("returns correct article comment") {
                        expect(outputArticleComment.events) == [
                            .next(0, inputArticleComment),
                            .completed(0)
                        ]
                    }
                }

                context("when articleCommentRepository.createComment() returns failure") {

                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Error?.self)
                        articleCommentRepository.createCommentArticleSlugCommentBodyReturnValue =
                            .error(TestError.mock)

                        usecase.execute(articleSlug: "", commentBody: "")
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
