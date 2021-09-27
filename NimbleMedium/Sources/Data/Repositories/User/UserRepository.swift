//
//  UserRepository.swift
//  NimbleMedium
//
//  Created by Minh Pham on 27/09/2021.
//

import RxSwift

final class UserRepository: UserRepositoryProtocol {

    private let networkAPI: NetworkAPIProtocol

    init(networkAPI: NetworkAPIProtocol) {
        self.networkAPI = networkAPI
    }

    func getUserProfile(username: String) -> Single<Profile> {
        let requestConfiguration = UserRequestConfiguration.profile(username: username)
        return networkAPI
            .performRequest(requestConfiguration, for: APIProfileResponse.self)
            .map { $0.profile as Profile }
    }
}
