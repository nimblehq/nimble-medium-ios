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

        registerRepositories()
        registerUseCases()
        registerViewModels()
    }

    private static func registerRepositories() {
        register {
            AuthRepository(networkAPI: resolve())
        }.implements(AuthRepositoryProtocol.self)
        register {
            ArticleRepository(networkAPI: resolve())
        }.implements(ArticleRepositoryProtocol.self)
        register {
            ArticleCommentRepository(networkAPI: resolve())
        }.implements(ArticleCommentRepositoryProtocol.self)
        register {
            UserRepository(networkAPI: resolve())
        }.implements(UserRepositoryProtocol.self)
        register {
            UserSessionRepository(keychain: resolve())
        }.implements(UserSessionRepositoryProtocol.self)
    }

    private static func registerUseCases() {
        register {
            GetArticleCommentsUseCase(articleCommentRepository: resolve())
        }.implements(GetArticleCommentsUseCaseProtocol.self)
        register {
            GetArticleUseCase(articleRepository: resolve())
        }.implements(GetArticleUseCaseProtocol.self)
        register {
            GetCurrentSessionUseCase(userSessionRepository: resolve())
        }.implements(GetCurrentSessionUseCaseProtocol.self)
        register {
            ListArticlesUseCase(articleRepository: resolve())
        }.implements(ListArticlesUseCaseProtocol.self)
        register {
            GetUserProfileUseCase(userRepository: resolve())
        }.implements(GetUserProfileUseCaseProtocol.self)
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
        register {
            GetArticleUseCase(articleRepository: resolve())
        }.implements(GetArticleUseCaseProtocol.self)
        register {
            GetArticleCommentsUseCase(articleCommentRepository: resolve())
        }.implements(GetArticleCommentsUseCaseProtocol.self)
        register {
            GetFavouritedArticlesUseCase(articleRepository: resolve())
        }.implements(GetFavouritedArticlesUseCaseProtocol.self)
    }

    private static func registerViewModels() {
        register { _, args in
            FeedCommentRowViewModel(comment: args.get())
        }.implements(FeedCommentRowViewModelProtocol.self)
        register { _, args in
            FeedCommentsViewModel(id: args.get())
        }.implements(FeedCommentsViewModelProtocol.self)
        register { _, args in
            FeedDetailViewModel(id: args.get())
        }.implements(FeedDetailViewModelProtocol.self)
        register { _, args in
            FeedRowViewModel(article: args.get())
        }.implements(FeedRowViewModelProtocol.self)
        register { FeedsViewModel() }.implements(FeedsViewModelProtocol.self).scope(.cached)
        register { HomeViewModel() }.implements(HomeViewModelProtocol.self).scope(.cached)
        register { LoginViewModel() }.implements(LoginViewModelProtocol.self).scope(.cached)
        register { SideMenuActionsViewModel() }.implements(SideMenuActionsViewModelProtocol.self).scope(.cached)
        register { SideMenuHeaderViewModel() }.implements(SideMenuHeaderViewModelProtocol.self).scope(.cached)
        register { SideMenuViewModel() }.implements(SideMenuViewModelProtocol.self).scope(.cached)
        register { SignupViewModel() }.implements(SignupViewModelProtocol.self).scope(.cached)
    }
}
