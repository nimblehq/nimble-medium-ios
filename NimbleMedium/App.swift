//
//  NimbleMediumApp.swift
//  NimbleMedium
//
//  Created by Mark G on 05/08/2021.
//

import SwiftUI
import AlamofireNetworkActivityLogger

@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }

    init() {
        #if DEBUG
        // Print alamofire request & response log
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
        #endif
    }
}
