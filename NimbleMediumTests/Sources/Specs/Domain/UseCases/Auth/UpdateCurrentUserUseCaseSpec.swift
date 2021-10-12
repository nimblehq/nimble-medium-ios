//
//  UpdateCurrentUserUseCaseSpec.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 12/10/2021.
//

import Quick
import Nimble
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class UpdateCurrentUserUseCaseSpec: QuickSpec {

    override func spec() {
        var usecase: UpdateCurrentUserUseCase!
        var authRepository: AuthRepositoryProtocolMock!
        var userSessionRepository: UserSessionRepositoryProtocolMock!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a GetCurrentUserUseCase") {

            beforeEach {
                disposeBag = DisposeBag()
                authRepository = AuthRepositoryProtocolMock()
                userSessionRepository = UserSessionRepositoryProtocolMock()
                usecase = UpdateCurrentUserUseCase(
                    authRepository: authRepository,
                    userSessionRepository: userSessionRepository
                )
                scheduler = TestScheduler(initialClock: 0)
            }

            describe("its execute() call") {

                let inputUser = APIUserResponse.dummy.user

                context("when authRepository.updateCurrentUser() and userSessionRepository.saveUser() return success") {

                    var outputCompleted: TestableObserver<Bool>!

                    beforeEach {
                        outputCompleted = scheduler.createObserver(Bool.self)
                        authRepository.updateCurrentUserUsernameEmailPasswordImageBioReturnValue = .just(inputUser)
                        userSessionRepository.saveUserReturnValue = .empty()

                        usecase.execute(username: "", email: "", password: nil, image: nil, bio: nil)
                            .asObservable()
                            .materialize()
                            .map { $0.isCompleted }
                            .bind(to: outputCompleted)
                            .disposed(by: disposeBag)
                    }

                    it("returns completed update current user event") {
                        expect(outputCompleted.events.first?.value.element) == true
                    }
                }

                context("when authRepository.updateCurrentUser() returns failure") {

                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Optional<Error>.self)
                        authRepository.updateCurrentUserUsernameEmailPasswordImageBioReturnValue =
                            .error(TestError.mock)
                        userSessionRepository.saveUserReturnValue = .empty()

                        usecase.execute(username: "", email: "", password: nil, image: nil, bio: nil)
                            .asObservable()
                            .materialize()
                            .map { $0.error }
                            .bind(to: outputError)
                            .disposed(by: disposeBag)
                    }

                    it("returns an error") {
                        let error = outputError.events.first?.value.element as? TestError

                        expect(outputError.events.count) == 2
                        expect(error) == TestError.mock
                        expect(outputError.events.last?.value.isCompleted) == true
                    }
                }

                context("when userSessionRepository.saveUser() returns failure") {

                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Optional<Error>.self)
                        authRepository.updateCurrentUserUsernameEmailPasswordImageBioReturnValue = .just(inputUser)
                        userSessionRepository.saveUserReturnValue = .error(TestError.mock)

                        usecase.execute(username: "", email: "", password: nil, image: nil, bio: nil)
                            .asObservable()
                            .materialize()
                            .map { $0.error }
                            .bind(to: outputError)
                            .disposed(by: disposeBag)
                    }

                    it("returns an error") {
                        let error = outputError.events.first?.value.element as? TestError

                        expect(outputError.events.count) == 2
                        expect(error) == TestError.mock
                        expect(outputError.events.last?.value.isCompleted) == true
                    }
                }
            }
        }
    }
}
