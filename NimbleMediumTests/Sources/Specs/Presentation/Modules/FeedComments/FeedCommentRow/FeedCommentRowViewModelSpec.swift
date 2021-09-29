//
//  FeedCommentRowViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Mark G on 23/09/2021.
//

import Quick
import Nimble
import RxNimble
import RxSwift
import RxTest
import Resolver

@testable import NimbleMedium

final class FeedCommentRowViewModelSpec: QuickSpec {

    override func spec() {
        var viewModel: FeedCommentRowViewModelProtocol!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var uiModel: FeedCommentRow.UIModel!

        describe("a FeedsViewModel") {

            beforeEach {
                Resolver.registerMockServices()

                let comment = APIArticleCommentsResponse.dummy.comments[0]
                uiModel = FeedCommentRow.UIModel(
                    commentBody: comment.body,
                    commentUpdatedAt: comment.updatedAt.format(with: .monthDayYear),
                    authorName: comment.author.username,
                    authorImage: try? comment.author.image?.asURL()
                )

                viewModel = FeedCommentRowViewModel(comment: comment)
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
            }

            it("returns output model with correct value") {
                expect(viewModel.output.uiModel)
                    .events(scheduler: scheduler, disposeBag: disposeBag) == [
                        .next(0, uiModel),
                        .completed(0)
                    ]
            }
        }
    }
}
