//
//  AuthRepository.swift
//  NimbleMedium
//
//  Created by Minh Pham on 26/08/2021.
//

import RxSwift

final class AuthRepository: AuthRepositoryProtocol {

    private let networkAPI: NetworkAPIProtocol
    private let authenticatedNetworkAPI: AuthenticatedNetworkAPIProtocol

    init(
        networkAPI: NetworkAPIProtocol,
        authenticatedNetworkAPI: AuthenticatedNetworkAPIProtocol
    ) {
        self.networkAPI = networkAPI
        self.authenticatedNetworkAPI = authenticatedNetworkAPI
    }

    func getCurrentUser() -> Single<User> {
        let requestConfiguration = AuthRequestConfiguration.user
        return authenticatedNetworkAPI
            .performRequest(requestConfiguration, for: APIUserResponse.self)
            .map { $0.user as User }
    }

    func login(email: String, password: String) -> Single<User> {
        let requestConfiguration = AuthRequestConfiguration.login(email: email, password: password)
        return networkAPI
            .performRequest(requestConfiguration, for: APIUserResponse.self)
            .map { $0.user as User }
    }

    func signup(username: String, email: String, password: String) -> Single<User> {
        let requestConfiguration = AuthRequestConfiguration.signup(username: username, email: email, password: password)
        return networkAPI
            .performRequest(requestConfiguration, for: APIUserResponse.self)
            .map { $0.user as User }
    }
}
