//
//  APIUser.swift
//  NimbleMedium
//
//  Created by Minh Pham on 30/08/2021.
//

import Foundation

struct APIUser: User, Decodable {
    let email: String
    let token: String
    let username: String
    let bio: String?
    let image: String?
}
