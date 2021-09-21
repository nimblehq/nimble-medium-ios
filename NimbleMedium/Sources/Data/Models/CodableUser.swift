//
//  APIUser.swift
//  NimbleMedium
//
//  Created by Minh Pham on 30/08/2021.
//

import Foundation

struct CodableUser: User, Codable {

    let email: String
    let token: String
    let username: String
    let bio: String?
    let image: String?

    init(user: User) {
        email = user.email
        token = user.token
        username = user.username
        bio = user.bio
        image = user.image
    }
}
