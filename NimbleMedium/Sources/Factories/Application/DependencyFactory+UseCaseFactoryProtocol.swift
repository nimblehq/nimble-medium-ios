//
//  DependencyFactory+UseCaseFactoryProtocol.swift
//  NimbleMedium
//
//  Created by Minh Pham on 26/08/2021.
//

extension DependencyFactory: UseCaseFactoryProtocol {

    func loginUseCase() -> LoginUseCaseProtocol {
        LoginUseCase(
            authRepository: authRepository(),
            userSessionRepository: userSessionRepository())
    }
}
