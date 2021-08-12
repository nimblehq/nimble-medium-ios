//
//  HomeView.swift
//  NimbleMedium
//
//  Created by Mark G on 06/08/2021.
//

import SwiftUI

struct HomeView: View {

    let feedsViewModel: FeedsViewModel
    let sideMenuViewModel: SideMenuViewModel

    var body: some View {
        ZStack {
            FeedsView(viewModel: feedsViewModel)
            SideMenuView(viewModel: sideMenuViewModel)
        }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {

    static var previews: some View {
        let sideMenuViewModel = SideMenuViewModel()
        let feedsViewModel = FeedsViewModel(sideMenuToggleResponder: sideMenuViewModel)

        return HomeView(
            feedsViewModel: feedsViewModel,
            sideMenuViewModel: sideMenuViewModel
        )
    }
}
#endif
