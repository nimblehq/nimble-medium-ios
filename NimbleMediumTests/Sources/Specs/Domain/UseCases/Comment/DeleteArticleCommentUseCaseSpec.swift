//
//  DeleteArticleCommentUseCaseSpec.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 21/10/2021.
//

import Nimble
import Quick
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class DeleteArticleCommentUseCaseSpec: QuickSpec {

    override func spec() {
        var usecase: DeleteArticleCommentUseCase!
        var articleCommentRepository: ArticleCommentRepositoryProtocolMock!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("an DeleteArticleCommentUseCase") {

            beforeEach {
                disposeBag = DisposeBag()
                articleCommentRepository = ArticleCommentRepositoryProtocolMock()
                usecase = DeleteArticleCommentUseCase(articleCommentRepository: articleCommentRepository)
                scheduler = TestScheduler(initialClock: 0)
            }

            describe("its execute() call") {

                context("when articleCommentRepository.deleteComment() returns success") {

                    var outputCompleted: TestableObserver<Bool>!

                    beforeEach {
                        outputCompleted = scheduler.createObserver(Bool.self)
                        articleCommentRepository.deleteCommentArticleSlugCommentIdReturnValue =
                            .empty()

                        usecase.execute(articleSlug: "", commentId: "")
                            .asObservable()
                            .materialize()
                            .map { $0.isCompleted }
                            .bind(to: outputCompleted)
                            .disposed(by: disposeBag)
                    }

                    it("returns completed delete article comment event") {
                        expect(outputCompleted.events.first?.value.element) == true
                    }
                }

                context("when articleCommentRepository.deleteComment() returns failure") {

                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Error?.self)
                        articleCommentRepository.deleteCommentArticleSlugCommentIdReturnValue =
                            .error(TestError.mock)

                        usecase.execute(articleSlug: "", commentId: "")
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
