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

        register { Keychain.default }.implements(KeychainProtocol.self).scope(.application)
        register { NetworkAPI() }.implements(NetworkAPIProtocol.self).scope(.application)
        register {
            AuthenticatedNetworkAPI(keychain: resolve())
        }.implements(AuthenticatedNetworkAPIProtocol.self).scope(.application)

        registerRepositories()
        registerUseCases()
        registerViewModels()
    }

    private static func registerRepositories() {
        register {
            AuthRepository(
                networkAPI: resolve(),
                authenticatedNetworkAPI: resolve()
            )
        }.implements(AuthRepositoryProtocol.self)
        register {
            ArticleRepository(
                authenticatedNetworkAPI: resolve(),
                networkAPI: resolve()
            )
        }.implements(ArticleRepositoryProtocol.self)
        register {
            ArticleCommentRepository(
                authenticatedNetworkAPI: resolve(),
                networkAPI: resolve()
            )
        }.implements(ArticleCommentRepositoryProtocol.self)
        register {
            UserRepository(
                networkAPI: resolve(),
                authenticatedNetworkAPI: resolve()
            )
        }.implements(UserRepositoryProtocol.self)
        register {
            UserSessionRepository(keychain: resolve())
        }.implements(UserSessionRepositoryProtocol.self)
    }

    // swiftlint:disable function_body_length
    private static func registerUseCases() {
        register {
            CreateArticleCommentUseCase(articleCommentRepository: resolve())
        }.implements(CreateArticleCommentUseCaseProtocol.self)
        register {
            CreateArticleUseCase(articleRepository: resolve())
        }.implements(CreateArticleUseCaseProtocol.self)
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
            GetCurrentUserUseCase(
                authRepository: resolve(),
                userSessionRepository: resolve()
            )
        }.implements(GetCurrentUserUseCaseProtocol.self)
        register {
            UpdateCurrentUserUseCase(
                authRepository: resolve(),
                userSessionRepository: resolve()
            )
        }.implements(UpdateCurrentUserUseCaseProtocol.self)
        register {
            GetListArticlesUseCase(articleRepository: resolve())
        }.implements(GetListArticlesUseCaseProtocol.self)
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
            LogoutUseCase(userSessionRepository: resolve())
        }.implements(LogoutUseCaseProtocol.self)
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
        register {
            GetCreatedArticlesUseCase(articleRepository: resolve())
        }.implements(GetCreatedArticlesUseCaseProtocol.self)
        register {
            UnfollowUserUseCase(userRepository: resolve())
        }.implements(UnfollowUserUseCaseProtocol.self)
        register {
            FollowUserUseCase(userRepository: resolve())
        }.implements(FollowUserUseCaseProtocol.self)
    }

    private static func registerViewModels() {
        register { _, args in
            ArticleCommentRowViewModel(comment: args.get())
        }.implements(ArticleCommentRowViewModelProtocol.self)
        register { _, args in
            ArticleCommentsViewModel(id: args.get())
        }.implements(ArticleCommentsViewModelProtocol.self)
        register { _, args in
            ArticleDetailViewModel(id: args.get())
        }.implements(ArticleDetailViewModelProtocol.self)
        register { _, args in
            ArticleRowViewModel(article: args.get())
        }.implements(ArticleRowViewModelProtocol.self)
        register { EditProfileViewModel() }.implements(EditProfileViewModelProtocol.self)
        register { FeedsViewModel() }.implements(FeedsViewModelProtocol.self).scope(.cached)
        register { HomeViewModel() }.implements(HomeViewModelProtocol.self).scope(.cached)
        register { LoginViewModel() }.implements(LoginViewModelProtocol.self).scope(.cached)
        register { SideMenuActionsViewModel() }.implements(SideMenuActionsViewModelProtocol.self).scope(.cached)
        register { SideMenuHeaderViewModel() }.implements(SideMenuHeaderViewModelProtocol.self).scope(.cached)
        register { SideMenuViewModel() }.implements(SideMenuViewModelProtocol.self).scope(.cached)
        register { SignupViewModel() }.implements(SignupViewModelProtocol.self).scope(.cached)
        register { _, args in
            UserProfileViewModel(username: args.get())
        }.implements(UserProfileViewModelProtocol.self)
        register { _, args in
            UserProfileCreatedArticlesTabViewModel(username: args.get())
        }.implements(UserProfileCreatedArticlesTabViewModelProtocol.self)
        register { _, args in
            UserProfileFavouritedArticlesTabViewModel(username: args.get())
        }.implements(UserProfileFavouritedArticlesTabViewModelProtocol.self)
    }
}
