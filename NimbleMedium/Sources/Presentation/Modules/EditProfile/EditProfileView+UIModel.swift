//
//  EditProfileView+UIModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 13/10/2021.
//

import Foundation

extension EditProfileView {

     struct UIModel: Equatable {

         let username: String
         let email: String
         let avatarURL: String
         let bio: String

         init(username: String = "", email: String = "", avatarURL: String = "", bio: String = "") {
             self.username = username
             self.email = email
             self.avatarURL = avatarURL
             self.bio = bio
         }
     }
 }
