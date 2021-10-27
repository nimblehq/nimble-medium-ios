//
//  FollowUserUseCaseSpec.swift
//  NimbleMediumTests
//
//  Created by Mark G on 12/10/2021.
//

import Nimble
import Quick
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class FollowUserUseCaseSpec: QuickSpec {

    override func spec() {
        var useCase: FollowUserUseCase!
        var userRepository: UserRepositoryProtocolMock!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a FollowUserUseCase") {

            beforeEach {
                disposeBag = DisposeBag()
                userRepository = UserRepositoryProtocolMock()
                useCase = FollowUserUseCase(userRepository: userRepository)
                scheduler = TestScheduler(initialClock: 0)
            }

            describe("its execute() call") {

                context("when userRepository.follow() returns success") {
                    var output: TestableObserver<Never>!

                    beforeEach {
                        output = scheduler.createObserver(Never.self)
                        userRepository.followUsernameReturnValue = .empty()

                        useCase.execute(username: "username")
                            .asObservable()
                            .bind(to: output)
                            .disposed(by: disposeBag)
                    }

                    it("emits complete event") {
                        expect(output).events() == [
                            .completed(0)
                        ]
                    }
                }

                context("when userRepository.follow() returns failure") {

                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Error?.self)
                        userRepository.followUsernameReturnValue = .error(TestError.mock)

                        useCase.execute(username: "username")
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
