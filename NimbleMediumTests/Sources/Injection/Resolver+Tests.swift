//
//  Resolver+Tests.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 14/09/2021.
//

import Foundation
import Resolver

@testable import NimbleMedium

extension Resolver {

    // MARK: - Mock Container

    static var mock = Resolver(parent: .main)

    // MARK: - Register Mock Services

    static func registerMockServices() {
        root = Resolver.mock
        defaultScope = .application
        registerRepositories()
        registerUseCases()
        registerViewModels()
    }

    private static func registerRepositories() {
        Resolver.mock.register { ArticleRepositoryProtocolMock() }
            .implements(ArticleRepositoryProtocol.self)
    }

    private static func registerUseCases() {
        Resolver.mock.register { CreateArticleCommentUseCaseProtocolMock() }
            .implements(CreateArticleCommentUseCaseProtocol.self)
        Resolver.mock.register { CreateArticleUseCaseProtocolMock() }
            .implements(CreateArticleUseCaseProtocol.self)
        Resolver.mock.register { GetArticleCommentsUseCaseProtocolMock() }
            .implements(GetArticleCommentsUseCaseProtocol.self)
        Resolver.mock.register { GetArticleUseCaseProtocolMock() }.implements(GetArticleUseCaseProtocol.self)
        Resolver.mock.register { GetCurrentSessionUseCaseProtocolMock() }
            .implements(GetCurrentSessionUseCaseProtocol.self)
        Resolver.mock.register { GetCurrentUserUseCaseProtocolMock() }.implements(GetCurrentUserUseCaseProtocol.self)
        Resolver.mock.register { GetGlobalArticlesUseCaseProtocolMock() }
            .implements(GetGlobalArticlesUseCaseProtocol.self)
        Resolver.mock.register { GetUserProfileUseCaseProtocolMock() }.implements(GetUserProfileUseCaseProtocol.self)
        Resolver.mock.register { LoginUseCaseProtocolMock() }.implements(LoginUseCaseProtocol.self)
        Resolver.mock.register { LogoutUseCaseProtocolMock() }.implements(LogoutUseCaseProtocol.self)
        Resolver.mock.register { GetCreatedArticlesUseCaseProtocolMock() }
            .implements(GetCreatedArticlesUseCaseProtocol.self)
        Resolver.mock.register { GetFavouritedArticlesUseCaseProtocolMock() }
            .implements(GetFavouritedArticlesUseCaseProtocol.self)
        Resolver.mock.register { UpdateCurrentUserUseCaseProtocolMock() }
            .implements(UpdateCurrentUserUseCaseProtocol.self)
        Resolver.mock.register { FollowUserUseCaseProtocolMock() }
            .implements(FollowUserUseCaseProtocol.self)
        Resolver.mock.register { UnfollowUserUseCaseProtocolMock() }
            .implements(UnfollowUserUseCaseProtocol.self)
        Resolver.mock.register { DeleteMyArticleUseCaseProtocolMock() }
            .implements(DeleteMyArticleUseCaseProtocol.self)
        Resolver.mock.register { ToggleArticleFavoriteStatusUseCaseProtocolMock() }
            .implements(ToggleArticleFavoriteStatusUseCaseProtocol.self)
        Resolver.mock.register { UpdateMyArticleUseCaseProtocolMock() }
            .implements(UpdateMyArticleUseCaseProtocol.self)
        Resolver.mock.register { DeleteArticleCommentUseCaseProtocolMock() }
            .implements(DeleteArticleCommentUseCaseProtocol.self)
    }

    private static func registerViewModels() {
        Resolver.mock.register { ArticleRowViewModelProtocolMock() }.implements(ArticleRowViewModelProtocol.self)
        Resolver.mock.register { HomeViewModelProtocolMock() }.implements(HomeViewModelProtocol.self)
        Resolver.mock.register { LoginViewModelProtocolMock() }.implements(LoginViewModelProtocol.self)
        Resolver.mock.register { SideMenuActionsViewModelProtocolMock() }
            .implements(SideMenuActionsViewModelProtocol.self)
        Resolver.mock.register { SideMenuHeaderViewModelProtocolMock() }
            .implements(SideMenuHeaderViewModelProtocol.self)
        Resolver.mock.register { SignupViewModelProtocolMock() }.implements(SignupViewModelProtocol.self)
    }
}
