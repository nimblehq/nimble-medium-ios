//
//  Profile.swift
//  NimbleMedium
//
//  Created by Mark G on 01/09/2021.
//

import Foundation

protocol Profile {

    var username: String { get }
    var bio: String? { get }
    var image: String? { get }
    var following: Bool { get }
}
