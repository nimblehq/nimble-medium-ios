//
//  Resolver+Tests.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 14/09/2021.
//

import Foundation
import Resolver

@testable import NimbleMedium

extension Resolver {

    // MARK: - Mock Container
    static var mock = Resolver(parent: .main)

    // MARK: - Register Mock Services
    static func registerMockServices() {
        root = Resolver.mock
        defaultScope = .application

        // UseCases
        Resolver.mock.register { LoginUseCaseProtocolMock() }.implements(LoginUseCaseProtocol.self)
    }
}
