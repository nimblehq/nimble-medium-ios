//
//  SideMenuHeaderViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 20/09/2021.
//

import Quick
import Nimble
import RxNimble
import RxSwift
import RxTest
import Resolver

@testable import NimbleMedium

final class SideMenuHeaderViewModelSpec: QuickSpec {

    @LazyInjected var homeViewModel: HomeViewModelProtocolMock
    @LazyInjected var getCurrentSessionUseCase: GetCurrentSessionUseCaseProtocolMock

    override func spec() {
        var viewModel: SideMenuHeaderViewModel!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a SideMenuHeaderViewModel") {

            beforeEach {
                Resolver.registerMockServices()
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                viewModel = SideMenuHeaderViewModel()
            }

            describe("its homeViewModel isSideMenuOpenDidChange call") {

                beforeEach {
                    let homeViewModelOutput = HomeViewModelOutputMock()
                    self.homeViewModel.output = homeViewModelOutput

                    homeViewModelOutput.underlyingIsSideMenuOpenDidChange = .just(true)
                }

                context("when there is a valid user session") {

                    let user = UserDummy()

                    beforeEach {
                        self.getCurrentSessionUseCase.getCurrentUserSessionReturnValue =
                            .just(user, on: scheduler, at: 50)
                        viewModel.input.bindData(homeViewModel: self.homeViewModel)
                    }

                    it("returns output with the correct uiModel") {
                        let expectedValue = SideMenuHeaderView.UIModel(
                            avatarURL: try? user.image?.asURL(),
                            username: user.username
                        )
                        expect(viewModel.output.uiModel)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .to(equal([
                                .next(0, nil),
                                .next(50, expectedValue)
                            ]))
                    }
                }

                context("when there is an invalid user session") {

                    beforeEach {
                        self.getCurrentSessionUseCase.getCurrentUserSessionReturnValue =
                            .just(nil, on: scheduler, at: 50)
                        viewModel.input.bindData(homeViewModel: self.homeViewModel)
                    }

                    it("returns output with a nil value") {
                        expect(viewModel.output.uiModel)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .to(equal([
                                .next(0, nil),
                                .next(50, nil)
                            ]))
                    }
                }

                context("when there is an error getting the user session") {

                    beforeEach {
                        self.getCurrentSessionUseCase.getCurrentUserSessionReturnValue =
                            .error(TestError.mock, on: scheduler, at: 50)
                        viewModel.input.bindData(homeViewModel: self.homeViewModel)
                    }

                    it("returns output with a nil value") {
                        expect(viewModel.output.uiModel)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .to(equal([
                                .next(0, nil),
                                .next(50, nil)
                            ]))
                    }
                }
            }

            context("when selectEditProfileOption is called") {

                beforeEach {
                    scheduler.scheduleAt(5) {
                        viewModel.input.selectEditProfileOption()
                    }
                }

                it("returns didSelectEditProfileOption output as true") {
                    expect(viewModel.output.didSelectEditProfileOption)
                        .events(scheduler: scheduler, disposeBag: disposeBag)
                        .to(equal([.next(5, true)]))
                }
            }
        }
    }
}
