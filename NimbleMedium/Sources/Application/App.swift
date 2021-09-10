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

    var factory: ModuleFactoryProtocol

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: factory.homeViewModel())
        }
    }

    init() {
        factory = DependencyFactory(keychain: Keychain.default, networkAPI: NetworkAPI())
        configureFirebase()
        configureNetworkLogger()
    }
}
