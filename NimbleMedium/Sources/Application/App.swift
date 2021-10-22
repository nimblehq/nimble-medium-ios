//
//  NimbleMediumApp.swift
//  NimbleMedium
//
//  Created by Mark G on 05/08/2021.
//

import SwiftUI

@main
struct App: SwiftUI.App {

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }

    init() {
        configureFirebase()
        configureNetworkLogger()
    }
}
