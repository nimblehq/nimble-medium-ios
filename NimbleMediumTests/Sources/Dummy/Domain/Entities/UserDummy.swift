//
//  UserDummy.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 20/09/2021.
//

@testable import NimbleMedium

struct UserDummy: User {

    var email: String { "email" }
    var token: String { "token" }
    var username: String { "username" }
    var bio: String? { nil }
    var image: String? { nil }

    var toSideMenuHeaderViewUiModel: SideMenuHeaderView.UiModel {
        SideMenuHeaderView.UiModel(avatarUrl: email, username: username)
    }
}
