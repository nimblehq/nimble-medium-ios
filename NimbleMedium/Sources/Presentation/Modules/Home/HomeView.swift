//
//  HomeView.swift
//  NimbleMedium
//
//  Created by Mark G on 06/08/2021.
//

import SwiftUI

struct HomeView<ViewModel: HomeViewModelProtocol, FeedsViewModel: FeedsViewModelProtocol>: View {

    @ObservedObject private var viewModel: ViewModel
    private let feedsViewModel: FeedsViewModel

    // swiftlint:disable type_contents_order
    init (viewModel: ViewModel, feedsViewModel: FeedsViewModel) {
        self.viewModel = viewModel
        self.feedsViewModel = feedsViewModel
    }

    var body: some View {
        ZStack {
            FeedsView(viewModel: feedsViewModel)
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.black.opacity(0.7))
            .opacity(viewModel.output.isSideMenuOpen ? 1.0 : 0.0)
            .animation(.easeIn(duration: 0.5))
            .onTapGesture {
                viewModel.input.toggleSideMenu(false)
            }

            HStack {
                GeometryReader { geo in
                    SideMenuView()
                        .frame(width: geo.size.width * 2 / 3, height: geo.size.height)
                        .background(Color.white)
                        .offset(x: viewModel.output.isSideMenuOpen ? 0 : -geo.size.width * 2 / 3)
                        .animation(.easeIn(duration: 0.5))
                }
            }
        }.ignoresSafeArea()
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {

    static var previews: some View {
        let homeViewModel = HomeViewModel()
        let feedsViewModel = FeedsViewModel(homeViewModelInput: homeViewModel.input)

        return HomeView(
            viewModel: homeViewModel,
            feedsViewModel: feedsViewModel
        )
    }
}
#endif
