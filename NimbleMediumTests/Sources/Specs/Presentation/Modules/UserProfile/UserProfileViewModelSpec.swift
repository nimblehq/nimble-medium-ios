//
//  UserProfileViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 04/10/2021.
//

import Quick
import Nimble
import RxNimble
import RxSwift
import RxTest
import Resolver

@testable import NimbleMedium

final class UserProfileViewModelSpec: QuickSpec {

    @LazyInjected var getCurrentUserUseCase: GetCurrentUserUseCaseProtocolMock
    @LazyInjected var getUserProfileUseCase: GetUserProfileUseCaseProtocolMock

    override func spec() {
        var viewModel: UserProfileViewModelProtocol!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a UserProfileViewModel") {

            beforeEach {
                Resolver.registerMockServices()
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
            }

            describe("its getUserProfile() call") {

                context("when there is a valid username") {

                    beforeEach {
                        viewModel = UserProfileViewModel(username: "username")
                    }

                    context("when GetUserProfileUseCase return success") {

                        let inputProfile = APIProfileResponse.dummy.profile

                        beforeEach {
                            self.getUserProfileUseCase.executeUsernameReturnValue =
                                .just(inputProfile, on: scheduler, at: 10)

                            scheduler.scheduleAt(5) {
                                viewModel.input.getUserProfile()
                            }
                        }

                        it("returns output userProfileUIModel with correct value") {
                            let expectedValue = UserProfileView.UIModel(
                                avatarURL: try? inputProfile.image?.asURL(),
                                username: inputProfile.username
                            )

                            expect(viewModel.output.userProfileUIModel)
                                .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                    .next(0, nil),
                                    .next(10, expectedValue)
                                ]
                        }
                    }

                    context("when GetUserProfileUseCase return failure") {

                        beforeEach {
                            self.getUserProfileUseCase.executeUsernameReturnValue =
                                .error(TestError.mock, on: scheduler, at: 10)

                            scheduler.scheduleAt(5) {
                                viewModel.input.getUserProfile()
                            }
                        }

                        it("returns output errorMessage with signal") {
                            expect(viewModel.output.errorMessage)
                                .events(scheduler: scheduler, disposeBag: disposeBag)
                                .notTo(beEmpty())
                        }
                    }
                }

                context("when there is no username provided") {

                    beforeEach {
                        viewModel = UserProfileViewModel()
                    }

                    context("when GetCurrentUserUseCase return success") {

                        let inputUser = APIUserResponse.dummy.user

                        beforeEach {
                            self.getCurrentUserUseCase.executeReturnValue =
                                .just(inputUser, on: scheduler, at: 10)

                            scheduler.scheduleAt(5) {
                                viewModel.input.getUserProfile()
                            }
                        }

                        it("returns output userProfileUIModel with correct value") {
                            let expectedValue = UserProfileView.UIModel(
                                avatarURL: try? inputUser.image?.asURL(),
                                username: inputUser.username
                            )

                            expect(viewModel.output.userProfileUIModel)
                                .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                    .next(0, nil),
                                    .next(10, expectedValue)
                                ]
                        }
                    }

                    context("when GetCurrentUserUseCase return failure") {

                        beforeEach {
                            self.getCurrentUserUseCase.executeReturnValue =
                                .error(TestError.mock, on: scheduler, at: 10)

                            scheduler.scheduleAt(5) {
                                viewModel.input.getUserProfile()
                            }
                        }

                        it("returns output errorMessage with signal") {
                            expect(viewModel.output.errorMessage)
                                .events(scheduler: scheduler, disposeBag: disposeBag)
                                .notTo(beEmpty())
                        }
                    }
                }
            }
        }
    }
}
