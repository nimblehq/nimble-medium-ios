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

    func getCurrentUser() -> Single<User> {
        let requestConfiguration = AuthRequestConfiguration.getCurrentUser
        return authenticatedNetworkAPI
            .performRequest(requestConfiguration, for: APIUserResponse.self)
            .map { $0.user as User }
    }

    func updateCurrentUser(
        username: String,
        email: String,
        password: String,
        image: String?,
        bio: String?
    ) -> Single<User> {
        let requestConfiguration = AuthRequestConfiguration.updateCurrentUser(
            username: username, email: email, password: password, image: image, bio: bio
        )
        return authenticatedNetworkAPI
            .performRequest(requestConfiguration, for: APIUserResponse.self)
            .map { $0.user as User }
    }
}
