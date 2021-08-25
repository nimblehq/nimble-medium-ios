//
//  HomeView.swift
//  NimbleMedium
//
//  Created by Mark G on 06/08/2021.
//

import SwiftUI
import RxSwift
import RxCocoa
import RxCombine

struct HomeView: View {

    private var viewModel: HomeViewModelProtocol

    @State private var isSideMenuOpen: Bool = false
    @State private var feedsViewModel: FeedsViewModelProtocol?
    @State private var sideMenuViewModel: SideMenuViewModelProtocol?

    var body: some View {
        ZStack {
            if let feedsViewModel = feedsViewModel {
                FeedsView(viewModel: feedsViewModel)
            }
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.black.opacity(0.7))
            .opacity(isSideMenuOpen ? 1.0 : 0.0)
            .animation(.easeIn(duration: 0.5))
            .onTapGesture {
                viewModel.input.toggleSideMenu(false)
            }

            HStack {
                GeometryReader { geo in
                    if let sideMenuViewModel = sideMenuViewModel {
                        SideMenuView(viewModel: sideMenuViewModel)
                            .frame(width: geo.size.width * 2.0 / 3.0, height: geo.size.height)
                            .background(Color.white)
                            .offset(x: isSideMenuOpen ? 0.0 : -geo.size.width * 2.0 / 3.0)
                            .animation(.easeIn(duration: 0.5))
                    }
                }
            }
        }
        .ignoresSafeArea()
        .onReceive(viewModel.output.isSideMenuOpen) {
            isSideMenuOpen = $0
        }
        .onReceive(viewModel.output.feedsViewModel) {
            feedsViewModel = $0
        }
        .onReceive(viewModel.output.sideMenuViewModel) {
            sideMenuViewModel = $0
        }
    }

    init (viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel(factory: DependencyFactory()))
    }
}
#endif
