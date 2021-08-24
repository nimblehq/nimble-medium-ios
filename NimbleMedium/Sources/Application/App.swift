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

    private var factory: ViewModelFactoryProtocol

    var body: some Scene {

        // TODO: Implement DI
        let feedsViewModel = FeedsViewModel()
        let homeViewModel = HomeViewModel(feedsViewModel: feedsViewModel)

        return WindowGroup {
            HomeView(factory: factory, viewModel: homeViewModel)
        }
    }

    init() {
        #if DEBUG
        // Print alamofire request & response log
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
        #endif

        self.factory = DependencyFactory()
    }
}
