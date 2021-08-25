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

    private var factory: ModuleFactoryProtocol

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: factory.homeViewModel())
        }
    }

    init() {
        #if DEBUG
        // Print alamofire request & response log
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
        #endif

        factory = DependencyFactory()
    }
}
