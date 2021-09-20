//
//  User.swift
//  NimbleMedium
//
//  Created by Minh Pham on 26/08/2021.
//

import Foundation

protocol User {

    var email: String { get }
    var token: String { get }
    var username: String { get }
    var bio: String? { get }
    var image: String? { get }

    var toSideMenuHeaderViewUiModel: SideMenuHeaderView.UiModel { get }
}
