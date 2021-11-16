//
//  HomeView.swift
//  NimbleMedium
//
//  Created by Mark G on 06/08/2021.
//

import Resolver
import RxCocoa
import RxCombine
import RxSwift
import SwiftUI

struct HomeView: View {

    @ObservedViewModel private var viewModel: HomeViewModelProtocol = Resolver.resolve()

    @Injected private var feedsViewModel: FeedsViewModelProtocol
    @Injected private var sideMenuViewModel: SideMenuViewModelProtocol

    @State private var isSideMenuOpen: Bool = false
    @State private var isDraggingEnabled = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                FeedsView()
                sideMenuDimmedBackground
                GeometryReader { geo in
                    SideMenuView()
                        .frame(width: geo.size.width * 2.0 / 3.0, height: geo.size.height)
                        .background(Color.white)
                        .offset(x: isSideMenuOpen ? 0 : -geo.size.width * 2.0 / 3.0)
                        .animation(.linear(duration: 0.3))
                }
            }
            .ignoresSafeArea()
            .onReceive(viewModel.output.isSideMenuOpenDidChange) { isOpen in
                isSideMenuOpen = isOpen
            }
        }
    }

    private var sideMenuDimmedBackground: some View {
        GeometryReader { _ in
            EmptyView()
        }
        .background(Color.black.opacity(0.7))
        .opacity(isSideMenuOpen ? 0.75 : 0)
        .animation(Animation.easeIn(duration: 0.3).delay(0.1))
        .onTapGesture {
            viewModel.input.toggleSideMenu(false)
        }
    }

    init() {
        viewModel.input.bindData(feedsViewModel: feedsViewModel, sideMenuViewModel: sideMenuViewModel)
    }
}

#if DEBUG
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View { HomeView() }
    }
#endif
