//
//  GetCurrentUserUseCaseSpec.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 29/09/2021.
//

import Quick
import Nimble
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class GetCurrentUserUseCaseSpec: QuickSpec {

    override func spec() {
        var usecase: GetCurrentUserUseCase!
        var authRepository: AuthRepositoryProtocolMock!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a GetCurrentUserUseCase") {

            beforeEach {
                disposeBag = DisposeBag()
                authRepository = AuthRepositoryProtocolMock()
                usecase = GetCurrentUserUseCase(authRepository: authRepository)
                scheduler = TestScheduler(initialClock: 0)
            }

            describe("its execute() call") {

                context("when authRepository.getCurrentUser() returns success") {

                    let inputUser = APIUserResponse.dummy.user
                    var outputUser: TestableObserver<CodableUser>!

                    beforeEach {
                        outputUser = scheduler.createObserver(CodableUser.self)
                        authRepository.getCurrentUserReturnValue = .just(inputUser)

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
                        outputError = scheduler.createObserver(Optional<Error>.self)
                        authRepository.getCurrentUserReturnValue =  .error(TestError.mock)

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
