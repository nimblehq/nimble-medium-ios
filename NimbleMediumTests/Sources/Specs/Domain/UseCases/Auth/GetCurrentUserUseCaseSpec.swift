//
//  GetCurrentUserUseCaseSpec.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 29/09/2021.
//

import Nimble
import Quick
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class GetCurrentUserUseCaseSpec: QuickSpec {

    override func spec() {
        var usecase: GetCurrentUserUseCase!
        var authRepository: AuthRepositoryProtocolMock!
        var userSessionRepository: UserSessionRepositoryProtocolMock!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a GetCurrentUserUseCase") {

            beforeEach {
                disposeBag = DisposeBag()
                authRepository = AuthRepositoryProtocolMock()
                userSessionRepository = UserSessionRepositoryProtocolMock()
                usecase = GetCurrentUserUseCase(
                    authRepository: authRepository,
                    userSessionRepository: userSessionRepository
                )
                scheduler = TestScheduler(initialClock: 0)
            }

            describe("its execute() call") {

                let inputUser = APIUserResponse.dummy.user

                context("when authRepository.getCurrentUser() and userSessionRepository.saveUser() returns success") {

                    var outputUser: TestableObserver<CodableUser>!

                    beforeEach {
                        outputUser = scheduler.createObserver(CodableUser.self)
                        authRepository.getCurrentUserReturnValue = .just(inputUser)
                        userSessionRepository.saveUserReturnValue = .empty()

                        usecase.execute()
                            .asObservable()
                            .compactMap {
                                $0 as? CodableUser
                            }
                            .bind(to: outputUser)
                            .disposed(by: disposeBag)
                    }

                    it("returns correct user") {
                        expect(outputUser.events) == [
                            .next(0, inputUser),
                            .completed(0)
                        ]
                    }
                }

                context("when authRepository.getCurrentUser() returns failure") {

                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Error?.self)
                        authRepository.getCurrentUserReturnValue = .error(TestError.mock)
                        userSessionRepository.saveUserReturnValue = .empty()

                        usecase.execute()
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
                        outputError = scheduler.createObserver(Error?.self)
                        authRepository.getCurrentUserReturnValue = .just(inputUser)
                        userSessionRepository.saveUserReturnValue = .error(TestError.mock)

                        usecase.execute()
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
