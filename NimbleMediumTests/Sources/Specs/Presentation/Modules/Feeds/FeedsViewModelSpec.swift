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

    @LazyInjected var sideMenuActionsViewModel: SideMenuActionsViewModelProtocolMock

    override func spec() {

        var viewModel: FeedsViewModelProtocol!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        var userSessionViewModel: UserSessionViewModelProtocolMock!

        var sideMenuActionsViewModelOutput: SideMenuActionsViewModelOutputMock!
        var userSessionViewModelInput: UserSessionViewModelInputMock!

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
                        articleFavoriteCount: article.favoritesCount,
                        articleCanFavorite: false,
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
                userSessionViewModel = UserSessionViewModelProtocolMock()

                sideMenuActionsViewModelOutput = SideMenuActionsViewModelOutputMock()
                sideMenuActionsViewModelOutput.underlyingDidLogout = .just(())
                sideMenuActionsViewModelOutput.underlyingDidLogin = .just(())
                self.sideMenuActionsViewModel.output = sideMenuActionsViewModelOutput

                userSessionViewModelInput = UserSessionViewModelInputMock()
                userSessionViewModel.input = userSessionViewModelInput
            }

            describe("its bindData call") {

                beforeEach {
                    bindData()
                }

                context("when sideMenuActionsViewModel didLogin emits event") {

                    it("calls userSessionViewModel's input getUserSession") {
                        expect(userSessionViewModelInput.getUserSessionCalled) == true
                    }
                }

                context("when sideMenuActionsViewModel didLogout emits event") {

                    it("calls userSessionViewModel's input getUserSession") {
                        expect(userSessionViewModelInput.getUserSessionCalled) == true
                    }
                }
            }

            describe("its toggleSideMenu call") {

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

            func bindData() {
                viewModel.input.bindData(
                    sideMenuActionsViewModel: sideMenuActionsViewModel,
                    userSessionViewModel: userSessionViewModel
                )
            }
        }
    }
}
