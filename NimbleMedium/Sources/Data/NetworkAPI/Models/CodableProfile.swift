//
//  CodableProfile.swift
//  NimbleMedium
//
//  Created by Mark G on 06/09/2021.
//

import Foundation
import DefaultCodable

struct CodableProfile: Profile, Codable, Equatable {

    let username: String
    let bio: String?
    let image: String?
    @Default<False> var following: Bool
}
