//
//  SideMenuViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 13/10/2021.
//

import Quick
import Nimble
import RxNimble
import RxSwift
import RxTest
import Resolver

@testable import NimbleMedium

final class SideMenuViewModelSpec: QuickSpec {

    @LazyInjected var sideMenuActionsViewModel: SideMenuActionsViewModelProtocolMock
    @LazyInjected var sideMenuHeaderViewModel: SideMenuHeaderViewModelProtocolMock

    override func spec() {

        var viewModel: SideMenuViewModel!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a SideMenuViewModel") {

            beforeEach {
                Resolver.registerMockServices()
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                viewModel = SideMenuViewModel()
            }

            describe("its bindData() call") {

                beforeEach {
                    let sideMenuActionsViewModelOutput = SideMenuActionsViewModelOutputMock()
                    self.sideMenuActionsViewModel.output = sideMenuActionsViewModelOutput
                    sideMenuActionsViewModelOutput.underlyingDidLogout = .just(())
                    sideMenuActionsViewModelOutput.underlyingDidSelectLoginOption = .just(true)
                    sideMenuActionsViewModelOutput.underlyingDidSelectMyProfileOption = .just(true)
                    sideMenuActionsViewModelOutput.underlyingDidSelectSignupOption = .just(true)

                    let sideMenuHeaderViewModelOutput = SideMenuHeaderViewModelOutputMock()
                    self.sideMenuHeaderViewModel.output = sideMenuHeaderViewModelOutput
                    sideMenuHeaderViewModelOutput.underlyingDidSelectEditProfileOption = .just(true)

                    scheduler.scheduleAt(5) {
                        viewModel.input.bindData(
                            sideMenuActionsViewModel: self.sideMenuActionsViewModel,
                            sideMenuHeaderViewModel: self.sideMenuHeaderViewModel
                        )
                    }
                }

                it("returns with didSelectEditProfileOption event") {
                    expect(viewModel.output.didSelectMenuOption)
                        .events(scheduler: scheduler, disposeBag: disposeBag)
                        .notTo(beEmpty())
                }
            }
        }
    }
}
