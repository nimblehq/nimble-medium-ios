//
//  GetUserProfileUseCaseSpec.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 27/09/2021.
//

import Quick
import Nimble
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class GetUserProfileUseCaseSpec: QuickSpec {

    override func spec() {
        var usecase: GetUserProfileUseCase!
        var userRepository: UserRepositoryProtocolMock!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("an UserRepository") {

            beforeEach {
                disposeBag = DisposeBag()
                userRepository = UserRepositoryProtocolMock()
                usecase = GetUserProfileUseCase(userRepository: userRepository)
                scheduler = TestScheduler(initialClock: 0)
            }

            describe("its execute() call") {

                context("when userRepository.getUserProfile() returns success") {

                    let inputProfile = APIProfileResponse.dummy.profile
                    var outputProfile: TestableObserver<DecodableProfile>!

                    beforeEach {
                        outputProfile = scheduler.createObserver(DecodableProfile.self)
                        userRepository.getUserProfileUsernameReturnValue = .just(inputProfile)

                        usecase.execute(username: "username")
                            .asObservable()
                            .compactMap {
                                $0 as? DecodableProfile
                            }
                            .bind(to: outputProfile)
                            .disposed(by: disposeBag)
                    }

                    it("returns correct profile") {
                        expect(outputProfile.events) == [
                            .next(0, inputProfile),
                            .completed(0)
                        ]
                    }
                }

                context("when userRepository.getUserProfile() returns failure") {

                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Optional<Error>.self)
                        userRepository.getUserProfileUsernameReturnValue = .error(TestError.mock)

                        usecase.execute(username: "username")
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
