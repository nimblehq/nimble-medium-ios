//
//  EditProfileView+UIModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 13/10/2021.
//

import Foundation

extension EditProfileView {

     struct UIModel: Equatable {

         var username: String
         var email: String
         var avatarURL: String
         var bio: String

         init(username: String = "", email: String = "", avatarURL: String = "", bio: String = "") {
             self.username = username
             self.email = email
             self.avatarURL = avatarURL
             self.bio = bio
         }

         var allFieldsAreEmpty: Bool {
             username.isEmpty &&
             email.isEmpty &&
             avatarURL.isEmpty &&
             bio.isEmpty
         }
     }
 }
