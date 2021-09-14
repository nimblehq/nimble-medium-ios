//
//  Resolver+Injection.swift
//  NimbleMedium
//
//  Created by Minh Pham on 14/09/2021.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {

    public static func registerAllServices() {
        defaultScope = .graph

        register { NetworkAPI() }.implements(NetworkAPIProtocol.self).scope(.application)
        register { Keychain.default }.implements(KeychainProtocol.self).scope(.application)

        // Repositories
        register {
            AuthRepository(networkAPI: resolve())
        }.implements(AuthRepositoryProtocol.self)
        register {
            UserSessionRepository(keychain: resolve())
        }.implements(UserSessionRepositoryProtocol.self)
        register {
            ArticleRepository(networkAPI: resolve())
        }.implements(ArticleRepositoryProtocol.self)

        // UseCases
        register {
            ListArticlesUseCase(articleRepository: resolve())
        }.implements(ListArticlesUseCaseProtocol.self)
        register {
            LoginUseCase(
                authRepository: resolve(),
                userSessionRepository: resolve()
            )
        }.implements(LoginUseCaseProtocol.self)
        register {
            SignupUseCase(
                authRepository: resolve(),
                userSessionRepository: resolve()
            )
        }.implements(SignupUseCaseProtocol.self)

        // ViewModels
        register { FeedsViewModel() }.implements(FeedsViewModelProtocol.self).scope(.cached)
        register { HomeViewModel() }.implements(HomeViewModelProtocol.self).scope(.cached)
        register { LoginViewModel() }.implements(LoginViewModelProtocol.self).scope(.cached)
        register { SideMenuActionsViewModel() }.implements(SideMenuActionsViewModelProtocol.self).scope(.cached)
        register { SideMenuViewModel() }.implements(SideMenuViewModelProtocol.self).scope(.cached)
        register { SignupViewModel() }.implements(SignupViewModelProtocol.self).scope(.cached)
    }
}
