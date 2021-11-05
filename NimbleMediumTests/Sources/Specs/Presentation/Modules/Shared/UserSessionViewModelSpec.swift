//
//  UserSessionViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 01/11/2021.
//

import Nimble
import Quick
import Resolver
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class UserSessionViewModelSpec: QuickSpec {

    @LazyInjected var getCurrentSessionUseCase: GetCurrentSessionUseCaseProtocolMock

    override func spec() {
        var viewModel: UserSessionViewModelProtocol!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a UserSessionViewModel") {

            beforeEach {
                Resolver.registerMockServices()
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                viewModel = UserSessionViewModel()
            }

            describe("its getUserSession call") {

                context("when getCurrentSessionUseCase returns a valid user session") {

                    let user = UserDummy()

                    beforeEach {
                        self.getCurrentSessionUseCase.executeReturnValue =
                            .just(user, on: scheduler, at: 50)
                        viewModel.input.getUserSession()
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
                        viewModel.input.getUserSession()
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
                        viewModel.input.getUserSession()
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
