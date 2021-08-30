//
//  DependencyFactory.swift
//  NimbleMedium
//
//  Created by Minh Pham on 24/08/2021.
//

// TODO: Support more protocols later
protocol ModuleFactoryProtocol: ViewModelFactoryProtocol, UseCaseFactoryProtocol {}

final class DependencyFactory {

    private let networkAPI: NetworkAPIProtocol

    init(networkAPI: NetworkAPIProtocol) {
        self.networkAPI = networkAPI
    }
}

// MARK: - RepositoryFactoryProtocol

extension DependencyFactory: RepositoryFactoryProtocol {

    func authRepository() -> AuthRepositoryProtocol {
        AuthRepository(networkAPI: networkAPI)
    }
}

extension DependencyFactory: ModuleFactoryProtocol {}
