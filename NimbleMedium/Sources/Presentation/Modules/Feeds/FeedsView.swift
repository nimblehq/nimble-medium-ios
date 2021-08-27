//
//  FeedsView.swift
//  NimbleMedium
//
//  Created by Mark G on 11/08/2021.
//

import SwiftUI

struct FeedsView: View {

    @ObservedViewModel private var viewModel: FeedsViewModelProtocol

    var body: some View {
        NavigationView {
            // TODO: Implement Feeds UI
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
                    viewModel.input.toggleSideMenu()
                },
                label: {
                    Image(R.image.menuIcon.name)
                }
            )
        }
    }

    init(viewModel: FeedsViewModelProtocol) {
        self.viewModel = viewModel
    }
}

#if DEBUG
struct FeedsView_Previews: PreviewProvider {
    static var previews: some View {
        FeedsView(viewModel: FeedsViewModel())
    }
}
#endif
