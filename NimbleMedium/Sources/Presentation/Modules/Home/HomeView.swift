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
    private let disposeBag = DisposeBag()

    @State private var isSideMenuOpen: Bool = false
    @State private var feedsViewModel: FeedsViewModelProtocol?

    // swiftlint:disable type_contents_order
    init (viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
    }

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
                    SideMenuView()
                        .frame(width: geo.size.width * 2 / 3, height: geo.size.height)
                        .background(Color.white)
                        .offset(x: isSideMenuOpen ? 0 : -geo.size.width * 2 / 3)
                        .animation(.easeIn(duration: 0.5))
                }
            }
        }
        .ignoresSafeArea()
        .onReceive(viewModel.output.isSideMenuOpen) {
            self.isSideMenuOpen = $0
        }
        .onReceive(viewModel.output.feedsViewModel) {
            self.feedsViewModel = $0
        }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {

    static var previews: some View {
        let feedsViewModel = FeedsViewModel()
        let homeViewModel = HomeViewModel(feedsViewModel: feedsViewModel)

        return HomeView(
            viewModel: homeViewModel
        )
    }
}
#endif
