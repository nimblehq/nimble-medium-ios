//
//  ArticleRowViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Mark G on 20/09/2021.
//

import Nimble
import Quick
import Resolver
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class ArticleRowViewModelSpec: QuickSpec {

    override func spec() {
        var viewModel: ArticleRowViewModelProtocol!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var uiModel: ArticleRow.UIModel!

        describe("a FeedsViewModel") {

            beforeEach {
                Resolver.registerMockServices()

                let article = APIArticleResponse.dummy.article
                uiModel = ArticleRow.UIModel(
                    id: article.id,
                    articleTitle: article.title,
                    articleDescription: article.description,
                    articleUpdatedAt: article.updatedAt.format(with: .monthDayYear),
                    authorImage: try? article.author.image?.asURL(),
                    authorName: article.author.username
                )

                viewModel = ArticleRowViewModel(article: article)
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
