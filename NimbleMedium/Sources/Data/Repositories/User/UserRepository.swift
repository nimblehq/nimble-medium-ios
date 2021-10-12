//
//  UserRepository.swift
//  NimbleMedium
//
//  Created by Minh Pham on 27/09/2021.
//

import RxSwift

final class UserRepository: UserRepositoryProtocol {

    private let networkAPI: NetworkAPIProtocol
    private let authenticatedNetworkAPI: AuthenticatedNetworkAPIProtocol

    init(
        networkAPI: NetworkAPIProtocol,
        authenticatedNetworkAPI: AuthenticatedNetworkAPIProtocol
    ) {
        self.networkAPI = networkAPI
        self.authenticatedNetworkAPI = authenticatedNetworkAPI
    }

    func getUserProfile(username: String) -> Single<Profile> {
        let requestConfiguration = UserRequestConfiguration.profile(username: username)
        return networkAPI
            .performRequest(requestConfiguration, for: APIProfileResponse.self)
            .map { $0.profile as Profile }
    }

    func follow(username: String) -> Completable {
        let requestConfiguration = UserRequestConfiguration.follow(username: username)
        return authenticatedNetworkAPI
            .performRequest(requestConfiguration, for: APIProfileResponse.self)
            .asCompletable()
    }

    func unfollow(username: String) -> Completable {
        let requestConfiguration = UserRequestConfiguration.unfollow(username: username)
        return authenticatedNetworkAPI
            .performRequest(requestConfiguration, for: APIProfileResponse.self)
            .asCompletable()
    }
}
