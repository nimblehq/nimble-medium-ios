//
//  SideMenuActionsViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 11/10/2021.
//

import Nimble
import Quick
import Resolver
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class SideMenuActionsViewModelSpec: QuickSpec {

    @LazyInjected var loginViewModel: LoginViewModelProtocolMock
    @LazyInjected var signupViewModel: SignupViewModelProtocolMock

    @LazyInjected var logoutUseCase: LogoutUseCaseProtocolMock

    override func spec() {

        var viewModel: SideMenuActionsViewModel!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        var loginViewModelOutput: LoginViewModelOutputMock!
        var signupViewModelOutput: SignupViewModelOutputMock!

        describe("a SideMenuActionsViewModel") {

            beforeEach {
                Resolver.registerMockServices()
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                viewModel = SideMenuActionsViewModel()

                loginViewModelOutput = LoginViewModelOutputMock()
                loginViewModelOutput.underlyingDidSelectNoAccount = .just(())
                loginViewModelOutput.underlyingDidLogin = .just(())
                self.loginViewModel.output = loginViewModelOutput

                signupViewModelOutput = SignupViewModelOutputMock()
                signupViewModelOutput.underlyingDidSelectHaveAccount = .just(())
                self.signupViewModel.output = signupViewModelOutput
            }

            describe("its bindData call") {

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

                context("when loginViewModel didLogin emits event") {

                    it("returns output with didLogin as true") {
                        scheduler.scheduleAt(5) {
                            bindData()
                        }

                        expect(viewModel.output.didLogin)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
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
                loginViewModel: loginViewModel,
                signupViewModel: signupViewModel
            )
        }
    }
}
