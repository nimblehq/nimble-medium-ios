//
//  UserProfileFavouritedArticlesTabViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Mark G on 07/10/2021.
//

import Quick
import Nimble
import RxNimble
import RxSwift
import RxTest
import Resolver

@testable import NimbleMedium

// swiftlint:disable type_name
final class UserProfileFavouritedArticlesTabViewModelSpec: QuickSpec {

    @LazyInjected var getFavouritedArticlesUseCase: GetFavouritedArticlesUseCaseProtocolMock

    override func spec() {
        var viewModel: UserProfileFavouritedArticlesTabViewModelProtocol!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a UserProfileFavouritedArticlesTabViewModel") {

            beforeEach {
                Resolver.registerMockServices()
                viewModel = UserProfileFavouritedArticlesTabViewModel(username: "username")
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
            }

            describe("its fetch() call") {

                context("when GetFavouritedArticlesUseCase return success") {

                    let inputArticles = APIArticlesResponse.dummy.articles

                    beforeEach {
                        self.getFavouritedArticlesUseCase.executeUsernameReturnValue =
                            .just(inputArticles, on: scheduler, at: 10)

                        scheduler.scheduleAt(5) {
                            viewModel.input.fetchFavouritedArticles()
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

                    it("returns output didFetchFavouritedArticles with singal") {
                        expect(viewModel.output.didFetchFavouritedArticles)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }
                }

                context("when GetFavouritedArticlesUseCase return failure") {

                    beforeEach {
                        self.getFavouritedArticlesUseCase.executeUsernameReturnValue =
                            .error(TestError.mock, on: scheduler, at: 10)

                        scheduler.scheduleAt(5) {
                            viewModel.input.fetchFavouritedArticles()
                        }
                    }

                    it("returns output didFailToFetchFavouritedArticles with singal") {
                        expect(viewModel.output.didFailToFetchFavouritedArticles)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }
                }
            }
        }
    }
}
