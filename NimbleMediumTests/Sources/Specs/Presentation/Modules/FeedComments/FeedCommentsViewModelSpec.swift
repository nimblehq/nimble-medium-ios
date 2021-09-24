//
//  FeedCommentsViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Mark G on 17/09/2021.
//

import Quick
import Nimble
import RxNimble
import RxSwift
import RxTest
import Resolver

@testable import NimbleMedium

final class FeedCommentsViewModelSpec: QuickSpec {

    @LazyInjected var getArticleCommentsUseCase: GetArticleCommentsUseCaseProtocolMock

    override func spec() {
        var viewModel: FeedCommentsViewModelProtocol!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a FeedCommentsViewModel") {

            beforeEach {
                Resolver.registerMockServices()
                viewModel = FeedCommentsViewModel(id: "slug")
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
            }

            describe("its fetchComments() call") {

                context("when GetArticleCommentsUseCase return success") {
                    let inputComments = APIArticleCommentsResponse.dummy.comments

                    beforeEach {
                        self.getArticleCommentsUseCase.getCommentsSlugReturnValue = .just(
                            inputComments,
                            on: scheduler,
                            at: 10
                        )

                        scheduler.scheduleAt(5) {
                            viewModel.input.fetchComments()
                        }
                    }

                    it("returns output didFetchComments with signal") {
                        expect(viewModel.output.didFetchComments)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }

                    it("returns output article with correct value") {
                        expect(
                            viewModel.output.feedCommentRowViewModels
                                .map { $0.map { $0.output.id } }
                        )
                        .events(scheduler: scheduler, disposeBag: disposeBag) == [
                            .next(0, []),
                            .next(10, inputComments.map { $0.id })
                        ]
                    }
                }

                context("when GetArticleCommentsUseCase return failure") {

                    beforeEach {
                        self.getArticleCommentsUseCase.getCommentsSlugReturnValue = .error(
                            TestError.mock,
                            on: scheduler,
                            at: 10
                        )

                        scheduler.scheduleAt(5) {
                            viewModel.input.fetchComments()
                        }
                    }

                    it("returns output didFailToFetchComments with signal") {
                        expect(viewModel.output.didFailToFetchComments)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }
                }
            }
        }
    }
}
