//
//  DecodableProfile.swift
//  NimbleMedium
//
//  Created by Mark G on 06/09/2021.
//

import DefaultCodable
import Foundation

struct DecodableProfile: Profile, Decodable, Equatable {

    let username: String
    let bio: String?
    let image: String?
    @Default<False> var following: Bool
}
