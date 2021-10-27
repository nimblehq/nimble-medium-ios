//
//  UserRepositorySpec.swift
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

final class UserRepositorySpec: QuickSpec {

    override func spec() {
        var repository: UserRepository!
        var networkAPI: NetworkAPIProtocolMock!
        var authenticatedNetworkAPI: AuthenticatedNetworkAPIProtocolMock!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("an UserRepository") {

            beforeEach {
                disposeBag = DisposeBag()
                networkAPI = NetworkAPIProtocolMock()
                authenticatedNetworkAPI = AuthenticatedNetworkAPIProtocolMock()
                repository = UserRepository(
                    networkAPI: networkAPI,
                    authenticatedNetworkAPI: authenticatedNetworkAPI
                )
                scheduler = TestScheduler(initialClock: 0)
            }

            describe("its getUserProfile() call") {

                context("when the request returns success") {

                    var outputProfile: TestableObserver<DecodableProfile>!
                    let inputResponse = APIProfileResponse.dummy

                    beforeEach {
                        outputProfile = scheduler.createObserver(DecodableProfile.self)
                        networkAPI.setPerformRequestForReturnValue(Single.just(inputResponse))
                        repository.getUserProfile(username: "username")
                            .asObservable()
                            .compactMap { $0 as? DecodableProfile }
                            .bind(to: outputProfile)
                            .disposed(by: disposeBag)
                    }

                    it("returns correct profile") {
                        expect(outputProfile).events() == [
                            .next(0, inputResponse.profile),
                            .completed(0)
                        ]
                    }
                }

                context("when the request returns failure") {

                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Error?.self)
                        networkAPI.setPerformRequestForReturnValue(
                            Single<APIProfileResponse>.error(TestError.mock)
                        )
                        repository.getUserProfile(username: "username")
                            .asObservable()
                            .materialize()
                            .map { $0.error }
                            .bind(to: outputError)
                            .disposed(by: disposeBag)
                    }

                    it("returns correct error") {
                        let error = outputError.events.first?.value.element as? TestError

                        expect(outputError.events.count) == 2
                        expect(error) == TestError.mock
                        expect(outputError.events.last?.value.isCompleted) == true
                    }
                }
            }

            describe("its unfollow() call") {

                context("when the request returns success") {

                    var output: TestableObserver<Never>!
                    let inputResponse = APIProfileResponse.dummy

                    beforeEach {
                        output = scheduler.createObserver(Never.self)
                        authenticatedNetworkAPI.setPerformRequestForReturnValue(Single.just(inputResponse))
                        repository.unfollow(username: "username")
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

                context("when the request returns failure") {

                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Error?.self)
                        authenticatedNetworkAPI.setPerformRequestForReturnValue(
                            Single<APIProfileResponse>.error(TestError.mock)
                        )
                        repository.unfollow(username: "username")
                            .asObservable()
                            .materialize()
                            .map { $0.error }
                            .bind(to: outputError)
                            .disposed(by: disposeBag)
                    }

                    it("returns correct error") {
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
