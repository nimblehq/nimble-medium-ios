//
//  DependencyFactory.swift
//  NimbleMedium
//
//  Created by Minh Pham on 24/08/2021.
//

// sourcery: AutoMockable
protocol ModuleFactoryProtocol: ViewModelFactoryProtocol, UseCaseFactoryProtocol {}

final class DependencyFactory {

    private let keychain: KeychainProtocol
    private let networkAPI: NetworkAPIProtocol

    init(
        keychain: KeychainProtocol,
        networkAPI: NetworkAPIProtocol
    ) {
        self.keychain = keychain
        self.networkAPI = networkAPI
    }
}

// MARK: - RepositoryFactoryProtocol

extension DependencyFactory: RepositoryFactoryProtocol {

    func authRepository() -> AuthRepositoryProtocol {
        AuthRepository(networkAPI: networkAPI)
    }

    func userSessionRepository() -> UserSessionRepositoryProtocol {
        UserSessionRepository(keychain: keychain)
    }
}

extension DependencyFactory: ModuleFactoryProtocol {}
