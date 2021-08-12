//
//  SideMenuToggleResponder.swift
//  NimbleMedium
//
//  Created by Mark G on 12/08/2021.
//

import Foundation

protocol SideMenuToggleResponder {

    // swiftlint:disable discouraged_optional_boolean
    func toggle(_ value: Bool?)
}

extension SideMenuToggleResponder {

    // swiftlint:disable discouraged_optional_boolean
    func toggle(_ value: Bool? = nil) {
        toggle(value)
    }
}
