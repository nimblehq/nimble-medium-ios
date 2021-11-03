//
//  EditArticleViewModelSpec.swift
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

final class EditArticleViewModelSpec: QuickSpec {

    @LazyInjected var updateArticleUseCase: UpdateMyArticleUseCaseProtocolMock
    @LazyInjected var getArticleUseCase: GetArticleUseCaseProtocolMock

    override func spec() {
        var viewModel: EditArticleViewModelProtocol!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a EditArticleViewModel") {

            beforeEach {
                Resolver.registerMockServices()
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                viewModel = EditArticleViewModel(slug: "slug")
            }

            describe("its fetchArticle() call") {

                context("when GetArticleUseCase return success") {
                    let inputArticle = APIArticleResponse.dummy.article

                    beforeEach {
                        self.getArticleUseCase.executeSlugReturnValue = .just(inputArticle, on: scheduler, at: 10)

                        scheduler.scheduleAt(5) {
                            viewModel.input.fetchArticleDetail()
                        }
                    }

                    it("returns output uiModel with correct value") {
                        expect(viewModel.output.uiModel)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(0, nil),
                                .next(10, .init(
                                    title: inputArticle.title,
                                    description: inputArticle.description,
                                    articleBody: inputArticle.body,
                                    tagsList: inputArticle.tagList.joined(separator: ",")
                                ))
                            ]
                    }
                }

                context("when GetArticleUseCase return failure") {

                    beforeEach {
                        self.getArticleUseCase.executeSlugReturnValue = .error(TestError.mock, on: scheduler, at: 10)

                        scheduler.scheduleAt(5) {
                            viewModel.input.fetchArticleDetail()
                        }
                    }

                    it("returns output didFailToFetchArticleDetail with signal") {
                        expect(viewModel.output.didFailToFetchArticleDetail)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }
                }
            }

            describe("its didTapUpdateButton() call") {

                let inputArticle = APIArticleResponse.dummy.article

                context("when updateArticleUseCase return success") {

                    beforeEach {
                        self.getArticleUseCase.executeSlugReturnValue = .just(inputArticle)
                        self.updateArticleUseCase.executeSlugParamsReturnValue = .empty(on: scheduler, at: 10)

                        scheduler.scheduleAt(5) {
                            viewModel.input.didTapUpdateButton(
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

                    it("returns output with didUpdateArticle event") {
                        expect(viewModel.output.didUpdateArticle)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }
                }

                context("when updateArticleUseCase return failure") {

                    beforeEach {
                        self.getArticleUseCase.executeSlugReturnValue = .just(inputArticle)
                        self.updateArticleUseCase.executeSlugParamsReturnValue =
                            .error(TestError.mock, on: scheduler, at: 10)

                        scheduler.scheduleAt(5) {
                            viewModel.input.didTapUpdateButton(
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

                    it("returns output didFailToUpdateArticle with signal") {
                        expect(viewModel.output.didFailToUpdateArticle)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }
                }
            }
        }
    }
}
