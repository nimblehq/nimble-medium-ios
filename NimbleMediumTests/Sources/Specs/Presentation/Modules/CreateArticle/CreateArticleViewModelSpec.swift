//
//  CreateArticleViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 19/10/2021.
//

import Nimble
import Quick
import Resolver
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class CreateArticleViewModelSpec: QuickSpec {

    @LazyInjected var createArticleUseCase: CreateArticleUseCaseProtocolMock

    override func spec() {
        var viewModel: CreateArticleViewModelProtocol!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a CreateArticleViewModel") {

            beforeEach {
                Resolver.registerMockServices()
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                viewModel = CreateArticleViewModel()
            }

            describe("its didTapPublishButton() call") {

                context("when createArticleUseCase return success") {

                    let inputArticle = APIArticleResponse.dummy.article

                    beforeEach {
                        self.createArticleUseCase.executeParamsReturnValue = .just(inputArticle, on: scheduler, at: 10)

                        scheduler.scheduleAt(5) {
                            viewModel.input.didTapPublishButton(
                                title: "",
                                description: "",
                                body: "",
                                tagsList: ""
                            )
                        }
                    }

                    it("returns output with isLoading as true then false accordingly") {
                        expect(viewModel.output.isLoading)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(0, false), // Initial state
                                .next(5, true), // Start loading
                                .next(10, false) // Loading complete
                            ]
                    }

                    it("returns output with didCreateArticle event") {
                        expect(viewModel.output.didCreateArticle)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }
                }

                context("when createArticleUseCase return failure") {

                    beforeEach {
                        self.createArticleUseCase.executeParamsReturnValue =
                            .error(TestError.mock, on: scheduler, at: 10)

                        scheduler.scheduleAt(5) {
                            viewModel.input.didTapPublishButton(
                                title: "",
                                description: "",
                                body: "",
                                tagsList: ""
                            )
                        }
                    }

                    it("returns output with isLoading as true then false accordingly") {
                        expect(viewModel.output.isLoading)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(0, false), // Initial state
                                .next(5, true), // Start loading
                                .next(10, false) // Loading complete
                            ]
                    }

                    it("returns output the corresponding errorMessage") {
                        expect(viewModel.output.errorMessage)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }
                }
            }
        }
    }
}
