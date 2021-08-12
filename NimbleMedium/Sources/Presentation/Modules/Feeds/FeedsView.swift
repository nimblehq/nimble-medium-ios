//
//  FeedsView.swift
//  NimbleMedium
//
//  Created by Mark G on 11/08/2021.
//

import SwiftUI

struct FeedsView: View {

    @ObservedObject var viewModel: FeedsViewModel

    var body: some View {
        NavigationView {
            // TODO: Implement feeds content UI
            Text("This is feed content")
                .navigationTitle(Localizable.feedTitle())
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarColor(backgroundColor: .green)
                .toolbar { navigationBarLeadingContent }
        }
    }

    var navigationBarLeadingContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(
                action: {
                    viewModel.toggleSideMenu()
                },
                label: {
                    Image(R.image.menuIcon.name)
                }
            )
        }
    }
}

#if DEBUG
struct FeedsView_Previews: PreviewProvider {
    static var previews: some View {
        let sideMenuViewModel = SideMenuViewModel()
        let feedsViewModel = FeedsViewModel(sideMenuToggleResponder: sideMenuViewModel)

        return FeedsView(viewModel: feedsViewModel)
    }
}
#endif
