//
//  SideMenuActionsViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 11/10/2021.
//

import Quick
import Nimble
import RxNimble
import RxSwift
import RxTest
import Resolver

@testable import NimbleMedium

final class SideMenuActionsViewModelSpec: QuickSpec {

    @LazyInjected var homeViewModel: HomeViewModelProtocolMock
    @LazyInjected var loginViewModel: LoginViewModelProtocolMock
    @LazyInjected var signupViewModel: SignupViewModelProtocolMock
    
    @LazyInjected var logoutUseCase: LogoutUseCaseProtocolMock
    @LazyInjected var getCurrentSessionUseCase: GetCurrentSessionUseCaseProtocolMock

    override func spec() {

        var viewModel: SideMenuActionsViewModel!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        var homeViewModelOutput: HomeViewModelOutputMock!
        var loginViewModelOutput: LoginViewModelOutputMock!
        var signupViewModelOutput: SignupViewModelOutputMock!

        describe("a SideMenuActionsViewModel") {

            beforeEach {
                Resolver.registerMockServices()
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                viewModel = SideMenuActionsViewModel()

                homeViewModelOutput = HomeViewModelOutputMock()
                homeViewModelOutput.underlyingIsSideMenuOpenDidChange = .just(false)
                self.homeViewModel.output = homeViewModelOutput

                loginViewModelOutput = LoginViewModelOutputMock()
                loginViewModelOutput.underlyingDidSelectNoAccount = .just(())
                self.loginViewModel.output = loginViewModelOutput

                signupViewModelOutput = SignupViewModelOutputMock()
                signupViewModelOutput.underlyingDidSelectHaveAccount = .just(())
                self.signupViewModel.output = signupViewModelOutput
            }

            describe("its bindData call") {

                context("when homeViewModel isSideMenuOpenDidChange emits event") {

                    beforeEach {
                        homeViewModelOutput.underlyingIsSideMenuOpenDidChange = .just(true)
                    }

                    context("when getCurrentSessionUseCase returns a valid user session") {

                        let user = UserDummy()

                        beforeEach {
                            self.getCurrentSessionUseCase.getCurrentUserSessionReturnValue =
                                .just(user, on: scheduler, at: 50)
                            bindData()
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
                            self.getCurrentSessionUseCase.getCurrentUserSessionReturnValue =
                                .just(nil, on: scheduler, at: 50)
                            bindData()
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
                            self.getCurrentSessionUseCase.getCurrentUserSessionReturnValue =
                                .error(TestError.mock, on: scheduler, at: 50)
                            bindData()
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

                context("when loginViewModel didSelectNoAccount emits event") {

                    it("returns output with didSelectSignupOption as true") {
                        scheduler.scheduleAt(5) {
                            bindData()
                        }

                        expect(viewModel.output.didSelectSignupOption)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .to(equal([.next(5, true)]))
                    }
                }

                context("when signupViewModel didSelectHaveAccount emits event") {

                    it("returns output with didSelectLoginOption as true") {
                        scheduler.scheduleAt(5) {
                            bindData()
                        }

                        expect(viewModel.output.didSelectLoginOption)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .to(equal([.next(5, true)]))
                    }
                }
            }

            describe("its selectLogoutOption call") {

                context("when logoutUseCase returns success") {

                    beforeEach {
                        self.logoutUseCase.executeReturnValue = .empty()
                    }

                    it("returns output with didLogout event") {
                        scheduler.scheduleAt(5) {
                            viewModel.input.selectLogoutOption()
                        }

                        expect(viewModel.output.didLogout)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }
                }

                context("when logoutUseCase returns failure") {

                    beforeEach {
                        self.logoutUseCase.executeReturnValue = .error(TestError.mock)
                    }

                    it("returns output without didLogout event") {
                        scheduler.scheduleAt(5) {
                            viewModel.input.selectLogoutOption()
                        }

                        expect(viewModel.output.didLogout)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .to(beEmpty())
                    }
                }
            }

            context("when selectLoginOption is called") {

                it("returns output with didSelectLoginOption as true") {
                    scheduler.scheduleAt(5) {
                        viewModel.input.selectLoginOption()
                    }

                    expect(viewModel.output.didSelectLoginOption)
                        .events(scheduler: scheduler, disposeBag: disposeBag)
                        .to(equal([.next(5, true)]))
                }
            }

            context("when selectMyProfileOption is called") {

                it("returns output with didSelectMyProfileOption as true") {
                    scheduler.scheduleAt(5) {
                        viewModel.input.selectMyProfileOption()
                    }

                    expect(viewModel.output.didSelectMyProfileOption)
                        .events(scheduler: scheduler, disposeBag: disposeBag)
                        .to(equal([.next(5, true)]))
                }
            }

            context("when selectSignupOption is called") {

                it("returns output with didSelectSignupOption as true") {
                    scheduler.scheduleAt(5) {
                        viewModel.input.selectSignupOption()
                    }

                    expect(viewModel.output.didSelectSignupOption)
                        .events(scheduler: scheduler, disposeBag: disposeBag)
                        .to(equal([.next(5, true)]))
                }
            }
        }

        func bindData() {
            viewModel.input.bindData(
                loginViewModel: self.loginViewModel,
                signupViewModel: self.signupViewModel,
                homeViewModel: self.homeViewModel
            )
        }
    }
}
