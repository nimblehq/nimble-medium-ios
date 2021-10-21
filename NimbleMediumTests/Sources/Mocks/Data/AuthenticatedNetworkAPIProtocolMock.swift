//
//  AuthenticatedNetworkAPIProtocolMock.swift
//  NimbleMediumTests
//
//  Created by Mark G on 12/10/2021.
//

import RxSwift

@testable import NimbleMedium

class AuthenticatedNetworkAPIProtocolMock: NetworkAPIProtocolMock, AuthenticatedNetworkAPIProtocol {

    var performRequestReturnValue: Completable = .empty()
    var performRequestReceivedArgument: RequestConfiguration?
    var performRequestReceivedInvocations: [RequestConfiguration] = []
    var performRequestCallsCount = 0
    var performRequestCalled: Bool {
        performRequestCallsCount > 0
    }

    func performRequest(_ configuration: RequestConfiguration) -> Completable {
        performRequestCallsCount += 1
        performRequestReceivedArgument = configuration
        performRequestReceivedInvocations.append(configuration)

        return performRequestReturnValue
    }
}
