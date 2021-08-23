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
        factory = DependencyFactory()
        configureFirebase()
        configureNetworkLogger()
    }

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: factory.homeViewModel())
        }
    }
}
