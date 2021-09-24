//
//  FeedRowViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Mark G on 20/09/2021.
//

import Quick
import Nimble
import RxNimble
import RxSwift
import RxTest
import Resolver

@testable import NimbleMedium

final class FeedRowViewModelSpec: QuickSpec {

    @LazyInjected var listArticlesUseCase: ListArticlesUseCaseProtocolMock

    override func spec() {
        var viewModel: FeedRowViewModelProtocol!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var uiModel: FeedRow.UIModel!

        describe("a FeedsViewModel") {

            beforeEach {
                Resolver.registerMockServices()

                let article = APIArticleResponse.dummy.article
                uiModel = FeedRow.UIModel(
                    id: article.id,
                    articleTitle: article.title,
                    articleDescription: article.description,
                    articleUpdatedAt: article.updatedAt.format(with: .monthDayYear),
                    authorImage: try? article.author.image?.asURL(),
                    authorName: article.author.username
                )

                viewModel = FeedRowViewModel(article: article)
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
