//
//  UserProfileFavoritedArticlesTabViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Mark G on 07/10/2021.
//

import Nimble
import Quick
import Resolver
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

// swiftlint:disable type_name
final class UserProfileFavoritedArticlesTabViewModelSpec: QuickSpec {

    @LazyInjected var getFavoritedArticlesUseCase: GetFavoritedArticlesUseCaseProtocolMock

    override func spec() {
        var viewModel: UserProfileFavoritedArticlesTabViewModelProtocol!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a UserProfileFavoritedArticlesTabViewModel") {

            beforeEach {
                Resolver.registerMockServices()
                Resolver.mock.register(ArticleRowViewModelProtocol.self) { _, args -> ArticleRowViewModelProtocolMock in
                    let article: Article = args.get()

                    let outputMock = ArticleRowViewModelOutputMock()
                    outputMock.underlyingIsTogglingFavoriteArticle = .just(false)
                    outputMock.underlyingDidToggleFavoriteArticle = .just(true)
                    outputMock.underlyingId = article.id

                    let mock = ArticleRowViewModelProtocolMock()
                    mock.underlyingOutput = outputMock
                    return mock
                }
                .scope(.unique)
                viewModel = UserProfileFavoritedArticlesTabViewModel(username: "username")
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
            }

            describe("its fetch() call") {

                context("when GetFavoritedArticlesUseCase return success") {

                    let inputArticles = APIArticlesResponse.dummy.articles

                    beforeEach {
                        self.getFavoritedArticlesUseCase.executeUsernameReturnValue =
                            .just(inputArticles, on: scheduler, at: 10)

                        scheduler.scheduleAt(5) {
                            viewModel.input.fetchFavoritedArticles()
                        }
                    }

                    it("returns output articleRowVieModels with correct value") {
                        let expectedValue = inputArticles
                            .map { $0.id }

                        expect(
                            viewModel.output.articleRowVieModels
                                .map { $0.map { $0.output.id } }
                        )
                        .events(scheduler: scheduler, disposeBag: disposeBag) == [
                            .next(0, []),
                            .next(10, expectedValue)
                        ]
                    }

                    it("returns output didFetchFavoritedArticles with singal") {
                        expect(viewModel.output.didFetchFavoritedArticles)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }
                }

                context("when GetFavoritedArticlesUseCase return failure") {

                    beforeEach {
                        self.getFavoritedArticlesUseCase.executeUsernameReturnValue =
                            .error(TestError.mock, on: scheduler, at: 10)

                        scheduler.scheduleAt(5) {
                            viewModel.input.fetchFavoritedArticles()
                        }
                    }

                    it("returns output didFailToFetchFavoritedArticles with singal") {
                        expect(viewModel.output.didFailToFetchFavoritedArticles)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }
                }
            }
        }
    }
}
