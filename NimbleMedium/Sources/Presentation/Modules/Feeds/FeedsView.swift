//
//  FeedsView.swift
//  NimbleMedium
//
//  Created by Mark G on 11/08/2021.
//

import SwiftUI
import Refresh

struct FeedsView: View {

    @ObservedViewModel private var viewModel: FeedsViewModelProtocol
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(1...3, id: \.self) { _ in
                        FeedRow()
                            .padding(.bottom, 16.0)
                    }

                    // TODO: Integrate load more
                    RefreshFooter(
                        refreshing: Binding.constant(true),
                        action: {
                            print("load more")
                        },
                        label: {
                            ProgressView()
                        }
                    )
                }
                .padding(.all, 16.0)

            }
            .enableRefresh()
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
