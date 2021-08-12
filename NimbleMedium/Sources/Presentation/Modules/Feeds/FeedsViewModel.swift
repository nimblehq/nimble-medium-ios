//
//  FeedsViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 12/08/2021.
//

import SwiftUI

class FeedsViewModel: ObservableObject {

    private let sideMenuToggleResponder: SideMenuToggleResponder

    init(sideMenuToggleResponder: SideMenuToggleResponder) {
        self.sideMenuToggleResponder = sideMenuToggleResponder
    }

    func toggleSideMenu() {
        sideMenuToggleResponder.toggle()
    }
}
