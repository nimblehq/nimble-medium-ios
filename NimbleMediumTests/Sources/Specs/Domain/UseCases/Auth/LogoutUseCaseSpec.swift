//
//  LogoutUseCaseSpec.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 11/10/2021.
//

import Nimble
import Quick
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class LogoutUseCaseSpec: QuickSpec {

    override func spec() {
        var usecase: LogoutUseCase!
        var userSessionRepository: UserSessionRepositoryProtocolMock!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("an LogoutUseCase") {

            beforeEach {
                disposeBag = DisposeBag()
                userSessionRepository = UserSessionRepositoryProtocolMock()
                usecase = LogoutUseCase(userSessionRepository: userSessionRepository)
                scheduler = TestScheduler(initialClock: 0)
            }

            describe("its execute() call") {

                context("when UserSessionRepository.removeCurrentUser() returns success") {

                    var outputCompleted: TestableObserver<Bool>!

                    beforeEach {
                        outputCompleted = scheduler.createObserver(Bool.self)
                        userSessionRepository.removeCurrentUserReturnValue = .empty()

                        usecase.execute()
                            .asObservable()
                            .materialize()
                            .map { $0.isCompleted }
                            .bind(to: outputCompleted)
                            .disposed(by: disposeBag)
                    }

                    it("returns completed logout event") {
                        expect(outputCompleted.events.first?.value.element) == true
                    }
                }

                context("when UserSessionRepository.removeCurrentUser() returns failure") {

                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Error?.self)
                        userSessionRepository.removeCurrentUserReturnValue = .error(TestError.mock)

                        usecase.execute()
                            .asObservable()
                            .materialize()
                            .map { $0.error }
                            .bind(to: outputError)
                            .disposed(by: disposeBag)
                    }

                    it("returns the corresponding error") {
                        let error = outputError.events.first?.value.element as? TestError
                        expect(error) == TestError.mock
                    }
                }
            }
        }
    }
}
