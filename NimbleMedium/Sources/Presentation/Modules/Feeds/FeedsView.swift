//
//  FeedsView.swift
//  NimbleMedium
//
//  Created by Mark G on 11/08/2021.
//

import PagerTabStripView
import Refresh
import Resolver
import SwiftUI
import ToastUI

struct FeedsView: View {

    @ObservedViewModel private var viewModel: FeedsViewModelProtocol = Resolver.resolve()
    @ObservedViewModel private var sideMenuActionsViewModel: SideMenuActionsViewModelProtocol = Resolver.resolve()

    @EnvironmentObject private var userSessionViewModel: UserSessionViewModel

    @State private var isFirstLoad: Bool = true
    @State private var isShowingCreateArticleScreen = false
    @State private var selectedTabIndex: Int = 0
    @State private var isAuthenticated = false

    var body: some View {
        NavigationView {
            Group {
                if isAuthenticated {
                    pagerTabs
                } else {
                    FeedsTabView(viewModel: viewModel.output.globalFeedsViewModel)
                }
            }
            .navigationTitle(Localizable.feedsTitle())
            .modifier(NavigationBarPrimaryStyle(isBackButtonHidden: true))
            .toolbar {
                navigationBarLeadingContent
                navigationBarTrailingContent
            }
        }
        .accentColor(.white)
        .onAppear {
            userSessionViewModel.input.getUserSession()
            viewModel.input.bindData(
                sideMenuActionsViewModel: sideMenuActionsViewModel,
                userSessionViewModel: userSessionViewModel
            )
        }
        .bind(userSessionViewModel.output.isAuthenticated, to: _isAuthenticated)
        .fullScreenCover(isPresented: $isShowingCreateArticleScreen) { CreateArticleView() }
    }

    var navigationBarLeadingContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(
                action: { viewModel.input.toggleSideMenu() },
                label: { Image(R.image.menuIcon.name) }
            )
        }
    }

    var navigationBarTrailingContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if isAuthenticated {
                Button(
                    action: { isShowingCreateArticleScreen = true },
                    label: { Image(systemName: SystemImageName.plusSquare.rawValue) }
                )
            }
        }
    }

    var pagerTabs: some View {
        PagerTabStripView(selection: $selectedTabIndex) {
            FeedsTabView(viewModel: viewModel.output.yourFeedsViewModel)
                .pagerTabItem { PagerTabItemTitle(Localizable.feedsYourFeedTabTitle()) }
            FeedsTabView(viewModel: viewModel.output.globalFeedsViewModel)
                .pagerTabItem { PagerTabItemTitle(Localizable.feedsGlobalFeedTabTitle()) }
        }
        .pagerTabStripViewStyle(
            .normal(
                indicatorBarColor: .green,
                tabItemHeight: 50.0,
                placedInToolbar: false
            )
        )
    }
}

#if DEBUG
    struct FeedsView_Previews: PreviewProvider {
        static var previews: some View {
            FeedsView()
        }
    }
#endif
