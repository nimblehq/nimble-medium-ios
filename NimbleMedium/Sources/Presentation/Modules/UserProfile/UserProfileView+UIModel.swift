//
//  UserProfileView+UIModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 23/09/2021.
//

import Foundation

extension UserProfileView {

     struct UIModel: Equatable {

        let avatarURL: URL?
        let username: String
        var isFollowing: Bool
     }
 }
