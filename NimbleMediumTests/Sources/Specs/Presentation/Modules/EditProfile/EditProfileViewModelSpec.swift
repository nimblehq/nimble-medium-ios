//
//  EditProfileViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 13/10/2021.
//

import Nimble
import Quick
import Resolver
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class EditProfileViewModelSpec: QuickSpec {

    @LazyInjected var getCurrentUserUseCase: GetCurrentUserUseCaseProtocolMock
    @LazyInjected var updateCurrentUserUseCase: UpdateCurrentUserUseCaseProtocolMock

    override func spec() {
        var viewModel: EditProfileViewModelProtocol!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a EditProfileViewModel") {

            beforeEach {
                Resolver.registerMockServices()
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                viewModel = EditProfileViewModel()
            }

            describe("its getCurrentUserProfile() call") {

                context("when getCurrentUserUseCase return success") {

                    let inputUser = APIUserResponse.dummy.user

                    beforeEach {
                        self.getCurrentUserUseCase.executeReturnValue =
                            .just(inputUser, on: scheduler, at: 10)

                        scheduler.scheduleAt(5) {
                            viewModel.input.getCurrentUserProfile()
                        }
                    }

                    it("returns output editProfileUIModel with correct value") {
                        let expectedValue = EditProfileView.UIModel(
                            username: inputUser.username,
                            email: inputUser.email,
                            avatarURL: inputUser.image ?? "",
                            bio: inputUser.bio ?? ""
                        )

                        expect(viewModel.output.editProfileUIModel)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(0, EditProfileView.UIModel()),
                                .next(10, expectedValue)
                            ]
                    }
                }

                context("when getCurrentUserUseCase return failure") {

                    beforeEach {
                        self.getCurrentUserUseCase.executeReturnValue =
                            .error(TestError.mock, on: scheduler, at: 10)

                        scheduler.scheduleAt(5) {
                            viewModel.input.getCurrentUserProfile()
                        }
                    }

                    it("returns output with the corresponding errorMessage") {
                        expect(viewModel.output.errorMessage)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }
                }
            }

            describe("its didTapUpdateButton() call") {

                context("when updateCurrentUserUseCase return success") {

                    beforeEach {
                        self.updateCurrentUserUseCase.executeParamsReturnValue = .empty()

                        scheduler.scheduleAt(5) {
                            viewModel.input.didTapUpdateButton(
                                username: "",
                                email: "",
                                password: "",
                                avatarURL: "",
                                bio: ""
                            )
                        }
                    }

                    it("returns output with isLoading as true then false accordingly") {
                        expect(viewModel.output.isLoading)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(0, false), // Initial state
                                .next(5, true), // Start loading
                                .next(5, false) // Loading complete
                            ]
                    }

                    it("returns output with didUpdateProfile event") {
                        expect(viewModel.output.didUpdateProfile)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }
                }

                context("when updateCurrentUserUseCase return failure") {

                    beforeEach {
                        self.updateCurrentUserUseCase.executeParamsReturnValue =
                            .error(TestError.mock)

                        scheduler.scheduleAt(5) {
                            viewModel.input.didTapUpdateButton(
                                username: "",
                                email: "",
                                password: "",
                                avatarURL: "",
                                bio: ""
                            )
                        }
                    }

                    it("returns output with isLoading as true then false accordingly") {
                        expect(viewModel.output.isLoading)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(0, false), // Initial state
                                .next(5, true), // Start loading
                                .next(5, false) // Loading complete
                            ]
                    }

                    it("returns output the corresponding errorMessage") {
                        expect(viewModel.output.errorMessage)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }
                }
            }
        }
    }
}
