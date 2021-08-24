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
    private var factory: ViewModelFactoryProtocol
    private let disposeBag = DisposeBag()

    @State private var isSideMenuOpen: Bool = false
    @State private var feedsViewModel: FeedsViewModelProtocol?

    // swiftlint:disable type_contents_order
    init (factory: ViewModelFactoryProtocol, viewModel: HomeViewModelProtocol) {
        self.factory = factory
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
                    SideMenuView(factory: factory) {
                        viewModel.input.toggleSideMenu(false)
                    }
                        .frame(width: geo.size.width * 2.0 / 3.0, height: geo.size.height)
                        .background(Color.white)
                        .offset(x: isSideMenuOpen ? 0.0 : -geo.size.width * 2.0 / 3.0)
                        .animation(.easeIn(duration: 0.5))
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
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let feedsViewModel = FeedsViewModel()
        let homeViewModel = HomeViewModel(feedsViewModel: feedsViewModel)
        let factory = DependencyFactory()
        return HomeView(factory: factory, viewModel: homeViewModel)
    }
}
#endif
