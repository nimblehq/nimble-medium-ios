//
//  SideMenuHeaderView+UiModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 20/09/2021.
//

import Foundation

extension SideMenuHeaderView {

    struct UIModel: Equatable {

        let avatarUrl: String?
        let username: String
    }
}

extension User {

    var toSideMenuHeaderViewUIModel: SideMenuHeaderView.UIModel {
        SideMenuHeaderView.UIModel(avatarUrl: image, username: username)
    }
}
