//
//  UserProfileCreatedArticlesTabViewModelSpec.swift
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
final class UserProfileCreatedArticlesTabViewModelSpec: QuickSpec {

    @LazyInjected var getCreatedArticlesUseCase: GetCreatedArticlesUseCaseProtocolMock

    override func spec() {
        var viewModel: UserProfileCreatedArticlesTabViewModelProtocol!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a UserProfileCreatedArticlesTabViewModel") {

            beforeEach {
                Resolver.registerMockServices()
                viewModel = UserProfileCreatedArticlesTabViewModel(username: "username")
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
            }

            describe("its fetch() call") {

                context("when GetCreatedArticlesUseCase return success") {

                    let inputArticles = APIArticlesResponse.dummy.articles

                    beforeEach {
                        self.getCreatedArticlesUseCase.executeUsernameReturnValue =
                            .just(inputArticles, on: scheduler, at: 10)

                        scheduler.scheduleAt(5) {
                            viewModel.input.fetchCreatedArticles()
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

                    it("returns output didFetchCreatedArticles with singal") {
                        expect(viewModel.output.didFetchCreatedArticles)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }
                }

                context("when GetCreatedArticlesUseCase return failure") {

                    beforeEach {
                        self.getCreatedArticlesUseCase.executeUsernameReturnValue =
                            .error(TestError.mock, on: scheduler, at: 10)

                        scheduler.scheduleAt(5) {
                            viewModel.input.fetchCreatedArticles()
                        }
                    }

                    it("returns output didFailToFetchCreatedArticles with singal") {
                        expect(viewModel.output.didFailToFetchCreatedArticles)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }
                }
            }
        }
    }
}
