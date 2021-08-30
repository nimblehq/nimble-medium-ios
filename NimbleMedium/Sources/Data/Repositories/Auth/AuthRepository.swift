//
//  AuthRepository.swift
//  NimbleMedium
//
//  Created by Minh Pham on 26/08/2021.
//

import RxSwift

final class AuthRepository: AuthRepositoryProtocol {

    private let networkAPI: NetworkAPIProtocol

    init(networkAPI: NetworkAPIProtocol) {
        self.networkAPI = networkAPI
    }

    func login(email: String, password: String) -> Single<User> {
        let requestConfiguration = AuthRequestConfiguration.login(email: email, password: password)
        return networkAPI
            .performRequest(requestConfiguration, for: APIUserResponse.self)
            .map { $0.user as User }
    }
}
