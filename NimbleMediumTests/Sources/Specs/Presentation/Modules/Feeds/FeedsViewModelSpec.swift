//
//  FeedsViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Mark G on 13/09/2021.
//

import Nimble
import Quick
import Resolver
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class FeedsViewModelSpec: QuickSpec {

    @LazyInjected var getCurrentSessionUseCase: GetCurrentSessionUseCaseProtocolMock

    override func spec() {
        var viewModel: FeedsViewModelProtocol!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a FeedsViewModel") {

            beforeEach {
                Resolver.registerMockServices()
                Resolver.mock.register { _, args -> ArticleRowViewModelProtocolMock in
                    let viewModel = ArticleRowViewModelProtocolMock()
                    let output = ArticleRowViewModelOutputMock()
                    viewModel.output = output

                    let article: Article = args.get()
                    let uiModel = ArticleRow.UIModel(
                        id: article.id,
                        articleTitle: article.title,
                        articleDescription: article.description,
                        articleUpdatedAt: article.updatedAt.format(with: .monthDayYear),
                        articleFavouriteCount: article.favoritesCount,
                        articleCanFavourite: false,
                        authorImage: try? article.author.image?.asURL(),
                        authorName: article.author.username
                    )
                    output.id = uiModel.id
                    output.uiModel = .just(uiModel)

                    return viewModel
                }
                .implements(ArticleRowViewModelProtocol.self)

                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                viewModel = FeedsViewModel()
            }

            describe("its toggleSideMenu() call") {

                beforeEach {
                    scheduler.scheduleAt(5) {
                        viewModel.input.toggleSideMenu()
                    }
                }

                it("returns output didToggleSideMenu with signal") {
                    expect(viewModel.output.didToggleSideMenu)
                        .events(scheduler: scheduler, disposeBag: disposeBag)
                        .notTo(beEmpty())
                }
            }

            describe("its viewOnAppear() call") {

                let user = UserDummy()

                beforeEach {
                    self.getCurrentSessionUseCase.executeReturnValue = .just(user)
                }

                context("when getCurrentSessionUseCase returns a valid user session") {

                    beforeEach {
                        self.getCurrentSessionUseCase.executeReturnValue =
                            .just(user, on: scheduler, at: 50)

                        viewModel.input.viewOnAppear()
                    }

                    it("returns output with isAuthenticated as true") {
                        expect(viewModel.output.isAuthenticated)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .to(equal([
                                .next(0, false),
                                .next(50, true)
                            ]))
                    }
                }

                context("when getCurrentSessionUseCase returns an invalid user session") {

                    beforeEach {
                        self.getCurrentSessionUseCase.executeReturnValue =
                            .just(nil, on: scheduler, at: 50)

                        viewModel.input.viewOnAppear()
                    }

                    it("returns output with isAuthenticated as false") {
                        expect(viewModel.output.isAuthenticated)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .to(equal([
                                .next(0, false),
                                .next(50, false)
                            ]))
                    }
                }

                context("when getCurrentSessionUseCase returns an error getting the user session") {

                    beforeEach {
                        self.getCurrentSessionUseCase.executeReturnValue =
                            .error(TestError.mock, on: scheduler, at: 50)

                        viewModel.input.viewOnAppear()
                    }

                    it("returns output with isAuthenticated as false") {
                        expect(viewModel.output.isAuthenticated)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .to(equal([
                                .next(0, false),
                                .next(50, false)
                            ]))
                    }
                }
            }
        }
    }
}
