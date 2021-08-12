//
//  SideMenuViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 11/08/2021.
//

import SwiftUI

class SideMenuViewModel: ObservableObject, SideMenuToggleResponder {

    @Published private(set) var isOpen: Bool = false

    // swiftlint:disable discouraged_optional_boolean
    func toggle(_ value: Bool?) {
        if let value = value {
            isOpen = value
            return
        }
        
        isOpen.toggle()
    }
}
