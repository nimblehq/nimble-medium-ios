//
//  ArticleRowViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Mark G on 20/09/2021.
//

import Nimble
import Quick
import Resolver
import RxCocoa
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class ArticleRowViewModelSpec: QuickSpec {

    @LazyInjected var toggleArticleFavoriteStatusUseCase: ToggleArticleFavoriteStatusUseCaseProtocolMock
    @LazyInjected var getCurrentSessionUseCase: GetCurrentSessionUseCaseProtocolMock

    override func spec() {
        var viewModel: ArticleRowViewModelProtocol!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var uiModel: ArticleRow.UIModel!
        let article = APIArticleResponse.dummy.article

        describe("a FeedsViewModel") {

            beforeEach {
                Resolver.registerMockServices()

                uiModel = ArticleRow.UIModel(
                    id: article.id,
                    articleTitle: article.title,
                    articleDescription: article.description,
                    articleUpdatedAt: article.updatedAt.format(with: .monthDayYear),
                    articleFavoriteCount: article.favoritesCount,
                    articleCanFavorite: false,
                    authorImage: try? article.author.image?.asURL(),
                    authorName: article.author.username
                )

                let user = APIUserResponse.dummy.user
                self.getCurrentSessionUseCase.executeReturnValue = .just(user)

                viewModel = ArticleRowViewModel(article: article)
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
            }

            it("returns output model with correct value") {
                expect(viewModel.output.uiModel)
                    .events(scheduler: scheduler, disposeBag: disposeBag) == [
                        .next(0, uiModel)
                    ]
            }

            describe("its toggleFavouriteArticle() call") {

                beforeEach {
                    SharingScheduler.mock(scheduler: scheduler) {
                        viewModel = ArticleRowViewModel(article: article)
                    }
                }

                context("when ToggleArticleFavoriteStatusUseCase return success") {

                    beforeEach {
                        self.toggleArticleFavoriteStatusUseCase
                            .executeSlugIsFavoriteReturnValue = .empty(on: scheduler, at: 10)

                        scheduler.scheduleAt(5) {
                            viewModel.input.toggleFavouriteArticle()
                        }
                    }

                    it("returns output uiModel with correct articleIsFavorited value") {
                        expect(
                            viewModel.output.uiModel
                                .map { $0?.articleIsFavorited }
                        )
                        .events(scheduler: scheduler, disposeBag: disposeBag) == [
                            .next(1, false),
                            .next(6, !article.favorited)
                        ]
                    }
                }

                context("when ToggleArticleFavoriteStatusUseCase return failure") {

                    beforeEach {
                        self.toggleArticleFavoriteStatusUseCase.executeSlugIsFavoriteReturnValue = .error(
                            TestError.mock,
                            on: scheduler,
                            at: 10
                        )

                        scheduler.scheduleAt(5) {
                            viewModel.input.toggleFavouriteArticle()
                        }
                    }

                    it("returns output didFailToToggleFavouriteArticle with signal") {
                        expect(viewModel.output.didFailToToggleFavouriteArticle)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }

                    it("reverts articleIsFavorited value") {
                        expect(
                            viewModel.output.uiModel
                                .map { $0?.articleIsFavorited }
                        )
                        .events(scheduler: scheduler, disposeBag: disposeBag) == [
                            .next(1, false),
                            .next(6, !article.favorited),
                            .next(11, article.favorited)
                        ]
                    }
                }
            }
        }
    }
}
