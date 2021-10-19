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
import RxCocoa
import Resolver

@testable import NimbleMedium

final class UserProfileViewModelSpec: QuickSpec {

    @LazyInjected var getCurrentUserUseCase: GetCurrentUserUseCaseProtocolMock
    @LazyInjected var getUserProfileUseCase: GetUserProfileUseCaseProtocolMock
    @LazyInjected var followUserUseCase: FollowUserUseCaseProtocolMock
    @LazyInjected var unfollowUserUseCase: UnfollowUserUseCaseProtocolMock

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
                                username: inputProfile.username,
                                isFollowing: inputProfile.following
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
                                username: inputUser.username,
                                isFollowing: false
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

            describe("its toggleFollowUser() call") {

                context("when there is a valid username") {

                    beforeEach {
                        SharingScheduler.mock(scheduler: scheduler) {
                            viewModel = UserProfileViewModel(username: "username")
                        }
                    }

                    context("when it toggles to follow") {
                        let inputProfile = APIProfileResponse.dummy.profile

                        beforeEach {
                            self.getUserProfileUseCase.executeUsernameReturnValue =
                                .just(inputProfile, on: scheduler, at: 10)
                            scheduler.scheduleAt(5) {
                                viewModel.input.getUserProfile()
                            }
                        }

                        context("when FollowUserUseCase return success") {

                            beforeEach {
                                self.followUserUseCase.executeUsernameReturnValue = .empty(on: scheduler, at: 20)
                                scheduler.scheduleAt(15) {
                                    viewModel.input.toggleFollowUser()
                                }
                            }

                            it("returns output uiModel with correct isFollowing value") {
                                expect(
                                    viewModel.output.userProfileUIModel
                                        .map { $0?.isFollowing }
                                )
                                .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                    .next(1, nil),
                                    .next(11, false),
                                    .next(16, true)
                                ]
                            }
                        }

                        context("when FollowUserUseCase return failure") {

                            beforeEach {
                                self.followUserUseCase.executeUsernameReturnValue = .error(
                                    TestError.mock,
                                    on: scheduler,
                                    at: 20
                                )
                                scheduler.scheduleAt(15) {
                                    viewModel.input.toggleFollowUser()
                                }
                            }

                            it("returns output didFailToToggleFollow with signal") {
                                expect(viewModel.output.didFailToToggleFollow)
                                    .events(scheduler: scheduler, disposeBag: disposeBag)
                                    .notTo(beEmpty())
                            }

                            it("reverts isFollowing value") {
                                expect(
                                    viewModel.output.userProfileUIModel
                                        .map { $0?.isFollowing }
                                )
                                .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                    .next(1, nil),
                                    .next(11, false),
                                    .next(16, true),
                                    .next(21, false)
                                ]
                            }
                        }
                    }

                    context("when it toggles to unfollow") {
                        let inputProfile = APIArticleResponse.dummyWithFollowingUser.article.author

                        beforeEach {
                            self.getUserProfileUseCase.executeUsernameReturnValue =
                                .just(inputProfile, on: scheduler, at: 10)
                            scheduler.scheduleAt(5) {
                                viewModel.input.getUserProfile()
                            }
                        }

                        context("when UnfollowUserUseCase return success") {

                            beforeEach {
                                self.unfollowUserUseCase.executeUsernameReturnValue = .empty(on: scheduler, at: 20)
                                scheduler.scheduleAt(15) {
                                    viewModel.input.toggleFollowUser()
                                }
                            }

                            it("returns output uiModel with correct isFollowing value") {
                                expect(
                                    viewModel.output.userProfileUIModel
                                        .map { $0?.isFollowing }
                                )
                                .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                    .next(1, nil),
                                    .next(11, true),
                                    .next(16, false)
                                ]
                            }
                        }

                        context("when FollowUserUseCase return failure") {

                            beforeEach {
                                self.unfollowUserUseCase.executeUsernameReturnValue = .error(
                                    TestError.mock,
                                    on: scheduler,
                                    at: 20
                                )
                                scheduler.scheduleAt(15) {
                                    viewModel.input.toggleFollowUser()
                                }
                            }

                            it("returns output didFailToToggleFollow with signal") {
                                expect(viewModel.output.didFailToToggleFollow)
                                    .events(scheduler: scheduler, disposeBag: disposeBag)
                                    .notTo(beEmpty())
                            }

                            it("reverts isFollowing value") {
                                expect(
                                    viewModel.output.userProfileUIModel
                                        .map { $0?.isFollowing }
                                )
                                .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                    .next(1, nil),
                                    .next(11, true),
                                    .next(16, false),
                                    .next(21, true)
                                ]
                            }
                        }
                    }
                }
            }
        }
    }
}
