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

    @ObservedViewModel private var viewModel: HomeViewModelProtocol

    var body: some View {
        ZStack {
            FeedsView(viewModel: viewModel.output.feedsViewModel)
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
                    SideMenuView(viewModel: viewModel.output.sideMenuViewModel)
                        .frame(width: geo.size.width * 2.0 / 3.0, height: geo.size.height)
                        .background(Color.white)
                        .offset(x: viewModel.output.isSideMenuOpen ? 0.0 : -geo.size.width * 2.0 / 3.0)
                        .animation(.easeIn(duration: 0.5))
                }
            }
        }
        .ignoresSafeArea()
    }

    init (viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let factory = DependencyFactory(networkAPI: NetworkAPI())
        let viewModel = HomeViewModel(factory: factory)
        return HomeView(viewModel: viewModel)
    }
}
#endif
