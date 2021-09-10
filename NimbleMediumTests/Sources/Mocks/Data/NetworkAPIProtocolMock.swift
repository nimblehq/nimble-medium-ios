//
//  NetworkAPIProtocolMock.swift
//  NimbleMediumTests
//
//  Created by Mark G on 08/09/2021.
//

import RxSwift

@testable import NimbleMedium

class NetworkAPIProtocolMock: NetworkAPIProtocol {

    private var performRequestForReturnValues: [String: Any] = [:]
    var performRequestForReceivedArguments: (configuration: RequestConfiguration, type: String)?
    var performRequestForReceivedInvocations: [(configuration: RequestConfiguration, type: String)] = []
    var performRequestForCallsCount = 0
    var performRequestForCalled: Bool {
        performRequestForCallsCount > 0
    }

    func performRequest<T: Decodable>(_ configuration: RequestConfiguration, for type: T.Type) -> Single<T> {
        performRequestForCallsCount += 1
        performRequestForReceivedArguments = (configuration: configuration, type: "\(type)")
        performRequestForReceivedInvocations.append((configuration: configuration, type: "\(type)"))

        // swiftlint:disable force_cast
        return getPerformRequestForReturnValue(for: T.self)
    }

    func setPerformRequestForReturnValue<T: Decodable>(_ value: Single<T>) {
        performRequestForReturnValues["\(T.self)"] = value
    }

    func getPerformRequestForReturnValue<T: Decodable>(for type: T.Type) -> Single<T> {
        performRequestForReturnValues["\(T.self)"] as! Single<T>
    }
}
