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

        register(KeychainProtocol.self) { Keychain.default }.scope(.application)
        register(NetworkAPIProtocol.self) { NetworkAPI() }.scope(.application)
        register(AuthenticatedNetworkAPIProtocol.self) {
            AuthenticatedNetworkAPI(keychain: resolve())
        }.scope(.application)

        registerRepositories()
        registerUseCases()
        registerViewModels()
    }

    private static func registerRepositories() {
        register(AuthRepositoryProtocol.self) {
            AuthRepository(
                networkAPI: resolve(),
                authenticatedNetworkAPI: resolve()
            )
        }
        register(ArticleRepositoryProtocol.self) {
            ArticleRepository(
                authenticatedNetworkAPI: resolve(),
                networkAPI: resolve()
            )
        }
        register(ArticleCommentRepositoryProtocol.self) {
            ArticleCommentRepository(
                authenticatedNetworkAPI: resolve(),
                networkAPI: resolve()
            )
        }
        register(UserRepositoryProtocol.self) {
            UserRepository(
                networkAPI: resolve(),
                authenticatedNetworkAPI: resolve()
            )
        }
        register(UserSessionRepositoryProtocol.self) {
            UserSessionRepository(keychain: resolve())
        }
    }

    // swiftlint:disable function_body_length
    private static func registerUseCases() {
        register(CreateArticleCommentUseCaseProtocol.self) {
            CreateArticleCommentUseCase(articleCommentRepository: resolve())
        }
        register(CreateArticleUseCaseProtocol.self) {
            CreateArticleUseCase(articleRepository: resolve())
        }
        register(DeleteArticleCommentUseCaseProtocol.self) {
            DeleteArticleCommentUseCase(articleCommentRepository: resolve())
        }
        register(DeleteMyArticleUseCaseProtocol.self) {
            DeleteMyArticleUseCase(articleRepository: resolve())
        }
        register(FollowUserUseCaseProtocol.self) {
            FollowUserUseCase(userRepository: resolve())
        }
        register(GetArticleCommentsUseCaseProtocol.self) {
            GetArticleCommentsUseCase(articleCommentRepository: resolve())
        }
        register(GetArticleUseCaseProtocol.self) {
            GetArticleUseCase(articleRepository: resolve())
        }
        register(GetCurrentSessionUseCaseProtocol.self) {
            GetCurrentSessionUseCase(userSessionRepository: resolve())
        }
        register(GetCurrentUserUseCaseProtocol.self) {
            GetCurrentUserUseCase(
                authRepository: resolve(),
                userSessionRepository: resolve()
            )
        }
        register(UpdateCurrentUserUseCaseProtocol.self) {
            UpdateCurrentUserUseCase(
                authRepository: resolve(),
                userSessionRepository: resolve()
            )
        }
        register(GetGlobalArticlesUseCaseProtocol.self) {
            GetGlobalArticlesUseCase(articleRepository: resolve())
        }
        register(GetCurrentUserFollowingArticlesUseCaseProtocol.self) {
            GetCurrentUserFollowingArticlesUseCase(
                articleRepository: resolve(),
                getCurrentSessionUseCase: resolve()
            )
        }
        register(GetUserProfileUseCaseProtocol.self) {
            GetUserProfileUseCase(userRepository: resolve())
        }
        register(LoginUseCaseProtocol.self) {
            LoginUseCase(
                authRepository: resolve(),
                userSessionRepository: resolve()
            )
        }
        register(LogoutUseCaseProtocol.self) {
            LogoutUseCase(userSessionRepository: resolve())
        }
        register(SignupUseCaseProtocol.self) {
            SignupUseCase(
                authRepository: resolve(),
                userSessionRepository: resolve()
            )
        }
        register(GetArticleUseCaseProtocol.self) {
            GetArticleUseCase(articleRepository: resolve())
        }
        register(GetArticleCommentsUseCaseProtocol.self) {
            GetArticleCommentsUseCase(articleCommentRepository: resolve())
        }
        register(GetFavouritedArticlesUseCaseProtocol.self) {
            GetFavouritedArticlesUseCase(articleRepository: resolve())
        }
        register(GetCreatedArticlesUseCaseProtocol.self) {
            GetCreatedArticlesUseCase(articleRepository: resolve())
        }
        register(ToggleArticleFavoriteStatusUseCaseProtocol.self) {
            ToggleArticleFavoriteStatusUseCase(articleRepository: resolve())
        }
        register(UnfollowUserUseCaseProtocol.self) {
            UnfollowUserUseCase(userRepository: resolve())
        }
        register(UpdateMyArticleUseCaseProtocol.self) {
            UpdateMyArticleUseCase(articleRepository: resolve())
        }
    }

    private static func registerViewModels() {
        register(ArticleCommentRowViewModelProtocol.self) { _, args in
            ArticleCommentRowViewModel(args: args.get())
        }
        register(ArticleCommentsViewModelProtocol.self) { _, args in
            ArticleCommentsViewModel(id: args.get())
        }.scope(.shared)
        register(ArticleDetailViewModelProtocol.self) { _, args in
            ArticleDetailViewModel(id: args.get())
        }
        register(ArticleRowViewModelProtocol.self) { _, args in
            ArticleRowViewModel(article: args.get())
        }
        register(CreateArticleViewModelProtocol.self) { CreateArticleViewModel() }
        register(EditArticleViewModelProtocol.self) { _, args in
            EditArticleViewModel(slug: args.get())
        }.scope(.shared)
        register(EditProfileViewModelProtocol.self) { EditProfileViewModel() }
        register(FeedsViewModelProtocol.self) { FeedsViewModel() }.scope(.cached)
        register(FeedsTabViewModelProtocol.self) { _, args in
            FeedsTabViewModel(tabType: args.get())
        }.scope(.unique)
        register(HomeViewModelProtocol.self) { HomeViewModel() }.scope(.cached)
        register(LoginViewModelProtocol.self) { LoginViewModel() }.scope(.shared)
        register(SideMenuActionsViewModelProtocol.self) { SideMenuActionsViewModel() }.scope(.shared)
        register(SideMenuHeaderViewModelProtocol.self) { SideMenuHeaderViewModel() }.scope(.shared)
        register(SideMenuViewModelProtocol.self) { SideMenuViewModel() }.scope(.shared)
        register(SignupViewModelProtocol.self) { SignupViewModel() }.scope(.shared)
        register(UserProfileViewModelProtocol.self) { _, args in
            UserProfileViewModel(username: args.get())
        }
        register(UserProfileCreatedArticlesTabViewModelProtocol.self) { _, args in
            UserProfileCreatedArticlesTabViewModel(username: args.get())
        }
        register(UserProfileFavouritedArticlesTabViewModelProtocol.self) { _, args in
            UserProfileFavouritedArticlesTabViewModel(username: args.get())
        }
    }
}
