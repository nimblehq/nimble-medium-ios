//
//  LoginViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 31/08/2021.
//

import Quick
import Nimble
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class LoginViewModelSpec: QuickSpec {

    override func spec() {
        var viewModel: LoginViewModel!
        var factory: ModuleFactoryProtocolMock!
        var loginUseCase: LoginUseCaseProtocolMock!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a LoginViewModel") {

            beforeEach {
                loginUseCase = LoginUseCaseProtocolMock()
                factory = ModuleFactoryProtocolMock()
                factory.loginUseCaseReturnValue = loginUseCase
                viewModel = LoginViewModel(factory: factory)
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
            }

            describe("its LoginButton click") {

                context("when logging in with email and password returns success") {

                    beforeEach {
                        loginUseCase.loginEmailPasswordReturnValue = Completable.create { completable in
                            scheduler.scheduleAt(100) {
                                completable(.completed)
                            }
                            return Disposables.create()
                        }

                        scheduler.scheduleAt(50) {
                            viewModel.input.didTapLoginButton(email: "test@nimblehq.co", password: "123456")
                        }
                    }

                    afterEach {
                        scheduler = nil
                    }

                    it("returns output didLogin with non empty signal") {
                        expect(viewModel.output.didLogin)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }

                    it("returns output isLoading with correct states") {
                        expect(viewModel.output.isLoading)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .to(equal([
                                .next(0, false),
                                .next(50, true),
                                .next(100, false)
                            ]))
                    }
                }

                context("when login with email and password returns failure") {

                    beforeEach {
                        loginUseCase.loginEmailPasswordReturnValue = Completable.create { completable in
                            scheduler.scheduleAt(100) {
                                completable(.error(TestError.mock))
                            }
                            return Disposables.create()
                        }

                        scheduler.scheduleAt(50) {
                            viewModel.input.didTapLoginButton(email: "test@nimblehq.co", password: "123456")
                        }
                    }

                    afterEach {
                        scheduler = nil
                    }

                    it("returns output didLogin with no signal") {
                        expect(viewModel.output.didLogin)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .to(beEmpty())
                    }

                    it("returns output with correct errorMessage") {
                        expect(viewModel.output.errorMessage)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .to(equal([.next(100, TestError.mock.detail)]))
                    }

                    it("returns output isLoading with correct states") {
                        expect(viewModel.output.isLoading)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .to(equal([
                                .next(0, false),
                                .next(50, true),
                                .next(100, false)
                            ]))
                    }
                }
            }

            describe("its NoAccountButton click") {
                
                it("returns output didSelectNoAccount with non empty signal") {
                    scheduler.scheduleAt(50) {
                        viewModel.input.didTapNoAccountButton()
                    }
                    
                    expect(viewModel.output.didSelectNoAccount)
                        .events(scheduler: scheduler, disposeBag: disposeBag)
                        .notTo(beEmpty())
                    
                    scheduler = nil
                }
            }
        }
    }
}
