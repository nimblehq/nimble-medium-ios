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


    // swiftlint:disable type_contents_order
    init() {
        configureFirebase()
        
        #if DEBUG
        // Print alamofire request & response log
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
        #endif
    }

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: factory.homeViewModel())
        }
    }
}
