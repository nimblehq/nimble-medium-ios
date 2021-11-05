//
//  FeedCommentRowViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Mark G on 23/09/2021.
//

import Nimble
import Quick
import Resolver
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class ArticleCommentRowViewModelSpec: QuickSpec {

    @LazyInjected var getCurrentSessionUseCase: GetCurrentSessionUseCaseProtocolMock
    @LazyInjected var deleteArticleCommentUseCase: DeleteArticleCommentUseCaseProtocolMock

    override func spec() {
        var viewModel: ArticleCommentRowViewModelProtocol!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var uiModel: ArticleCommentRow.UIModel!

        describe("a ArticleCommentRowViewModel") {

            beforeEach {
                Resolver.registerMockServices()
                self.getCurrentSessionUseCase.executeReturnValue = .just(nil)

                let comment = APIArticleCommentsResponse.dummy.comments[0]
                uiModel = ArticleCommentRow.UIModel(
                    commentBody: comment.body,
                    commentUpdatedAt: comment.updatedAt.format(with: .monthDayYear),
                    authorName: comment.author.username,
                    authorImage: try? comment.author.image?.asURL(),
                    isAuthor: false
                )

                viewModel = ArticleCommentRowViewModel(
                    args: .init(slug: "", comment: comment)
                )
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
            }

            it("returns output model with correct value") {
                expect(viewModel.output.uiModel)
                    .events(scheduler: scheduler, disposeBag: disposeBag) == [
                        .next(0, uiModel)
                    ]
            }

            describe("its deleteComment() call") {

                context("when DeleteArticleCommentUseCase return success") {

                    beforeEach {
                        self.deleteArticleCommentUseCase.executeArticleSlugCommentIdReturnValue = .empty(
                            on: scheduler,
                            at: 10
                        )

                        scheduler.scheduleAt(5) {
                            viewModel.input.deleteComment()
                        }
                    }

                    it("returns output didDeleteComment with signal") {
                        expect(viewModel.output.didDeleteComment)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }

                    it("returns output isLoading with correct value") {
                        expect(viewModel.output.isLoading)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(0, false),
                                .next(5, true),
                                .next(10, false)
                            ]
                    }
                }

                context("when DeleteArticleCommentUseCase return failure") {

                    beforeEach {
                        self.deleteArticleCommentUseCase.executeArticleSlugCommentIdReturnValue = .error(
                            TestError.mock,
                            on: scheduler,
                            at: 10
                        )

                        scheduler.scheduleAt(5) {
                            viewModel.input.deleteComment()
                        }
                    }

                    it("returns output didFailToDeleteComment with signal") {
                        expect(viewModel.output.didFailToDeleteComment)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }

                    it("returns output isLoading with correct value") {
                        expect(viewModel.output.isLoading)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(0, false),
                                .next(5, true),
                                .next(10, false)
                            ]
                    }
                }
            }
        }
    }
}
