//
//  ArticleCommentsViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Mark G on 17/09/2021.
//

import Nimble
import Quick
import Resolver
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class ArticleCommentsViewModelSpec: QuickSpec {

    @LazyInjected var getArticleCommentsUseCase: GetArticleCommentsUseCaseProtocolMock
    @LazyInjected var createArticleCommentUseCase: CreateArticleCommentUseCaseProtocolMock

    override func spec() {
        var viewModel: ArticleCommentsViewModelProtocol!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a ArticleCommentsViewModel") {

            beforeEach {
                Resolver.registerMockServices()
                viewModel = ArticleCommentsViewModel(id: "slug")
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
            }

            describe("its fetchComments() call") {

                context("when GetArticleCommentsUseCase return success") {
                    let inputComments = APIArticleCommentsResponse.dummy.comments

                    beforeEach {
                        self.getArticleCommentsUseCase.executeSlugReturnValue = .just(
                            inputComments,
                            on: scheduler,
                            at: 10
                        )

                        scheduler.scheduleAt(5) {
                            viewModel.input.fetchArticleComments()
                        }
                    }

                    it("returns output didFetchArticleComments with signal") {
                        expect(viewModel.output.didFetchArticleComments)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }

                    it("returns output article with correct value") {
                        expect(
                            viewModel.output.articleCommentRowViewModels
                                .map { $0.map { $0.output.id } }
                        )
                        .events(scheduler: scheduler, disposeBag: disposeBag) == [
                            .next(0, []),
                            .next(10, inputComments.map { $0.id })
                        ]
                    }

                    it("returns output isCreateCommentEnabled with correct value") {
                        expect(viewModel.output.isCreateCommentEnabled)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(0, false),
                                .next(10, true)
                            ]
                    }
                }

                context("when GetArticleCommentsUseCase return failure") {

                    beforeEach {
                        self.getArticleCommentsUseCase.executeSlugReturnValue = .error(
                            TestError.mock,
                            on: scheduler,
                            at: 10
                        )

                        scheduler.scheduleAt(5) {
                            viewModel.input.fetchArticleComments()
                        }
                    }

                    it("returns output didFailToFetchArticleComments with signal") {
                        expect(viewModel.output.didFailToFetchArticleComments)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }

                    it("returns output isCreateCommentEnabled with correct value") {
                        expect(viewModel.output.isCreateCommentEnabled)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(0, false),
                                .next(10, true)
                            ]
                    }
                }
            }

            describe("its createArticleComment() call") {

                context("when CreateArticleCommentUseCase return success") {
                    let inputComment = APIArticleCommentResponse.dummy.comment
                    let inputComments = APIArticleCommentsResponse.dummy.comments

                    beforeEach {
                        self.getArticleCommentsUseCase.executeSlugReturnValue = .just(inputComments)
                        self.createArticleCommentUseCase.executeArticleSlugCommentBodyReturnValue = .just(
                            inputComment,
                            on: scheduler,
                            at: 10
                        )

                        scheduler.scheduleAt(5) {
                            viewModel.input.createArticleComment(content: "")
                        }
                    }

                    it("returns output didCreateArticleComment with signal") {
                        expect(viewModel.output.didCreateArticleComment)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }

                    it("returns output isCreateCommentEnabled with correct value") {
                        expect(viewModel.output.isCreateCommentEnabled)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(0, false),
                                .next(5, false),
                                .next(10, true),
                                .next(10, true)
                            ]
                    }
                }

                context("when CreateArticleCommentUseCase return failure") {

                    beforeEach {
                        self.createArticleCommentUseCase.executeArticleSlugCommentBodyReturnValue = .error(
                            TestError.mock,
                            on: scheduler,
                            at: 10
                        )

                        scheduler.scheduleAt(5) {
                            viewModel.input.createArticleComment(content: "")
                        }
                    }

                    it("returns output didFailToCreateArticleComment with signal") {
                        expect(viewModel.output.didFailToCreateArticleComment)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }

                    it("returns output isCreateCommentEnabled with correct value") {
                        expect(viewModel.output.isCreateCommentEnabled)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(0, false),
                                .next(5, false),
                                .next(10, true)
                            ]
                    }
                }
            }
        }
    }
}
