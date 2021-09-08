//
//  CodableProfile.swift
//  NimbleMedium
//
//  Created by Mark G on 06/09/2021.
//

import Foundation

struct CodableProfile: Profile, Codable, Equatable {

    let username: String
    let bio: String?
    let image: String?
    @DecodableDefault.False var following: Bool
}
