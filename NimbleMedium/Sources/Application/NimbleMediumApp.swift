//
//  NimbleMediumApp.swift
//  NimbleMedium
//
//  Created by Mark G on 05/08/2021.
//

import SwiftUI

@main
struct NimbleMediumApp: App {

    @StateObject var userSessionViewModel = UserSessionViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(userSessionViewModel)
        }
    }

    init() {
        configureFirebase()
        configureNetworkLogger()
    }
}
