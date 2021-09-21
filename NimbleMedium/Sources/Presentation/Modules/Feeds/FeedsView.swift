//
//  FeedsView.swift
//  NimbleMedium
//
//  Created by Mark G on 11/08/2021.
//

import Refresh
import Resolver
import SwiftUI
import ToastUI

struct FeedsView: View {

    @ObservedViewModel private var viewModel: FeedsViewModelProtocol = Resolver.resolve()
    
    @State private var isFirstLoad: Bool = true
    @State private var isRefeshing: Bool = false
    @State private var hasMore: Bool = true
    @State private var isLoadingMore: Bool = false
    @State private var feedRowModels: [FeedRow.UIModel] = []
    @State private var isErrorToastPresented = false

    var body: some View {
        Content(view: self)
            .binding()
            .onAppear { viewModel.input.refresh() }
    }
}

// MARK: - Content
private extension FeedsView {

    struct Content: View {

        let view: FeedsView
        var viewModel: FeedsViewModelProtocol { view.viewModel }

        var body: some View {
            NavigationView {
                Group {
                    if view.isFirstLoad {
                        ProgressView()
                    } else {
                        feedList
                    }
                }
                .navigationTitle(Localizable.feedsTitle())
                .modifier(NavigationBarPrimaryStyle(isBackButtonHidden: true))
                .toolbar { navigationBarLeadingContent }
                .toast(isPresented: view.$isErrorToastPresented, dismissAfter: 3.0) {
                    ToastView(Localizable.errorGeneric()) { } background: {
                        Color.clear
                    }
                }
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

        var feedRows: some View {
            Group {
                RefreshHeader(
                    refreshing: view.$isRefeshing,
                    action: { viewModel.input.refresh() },
                    label: { _ in ProgressView() }
                )

                LazyVStack(alignment: .leading) {
                    ForEach(view.feedRowModels, id: \.id) {
                        FeedRow(model: $0)
                            .padding(.bottom, 16.0)
                    }
                }
                .padding(.all, 16.0)

                if view.hasMore {
                    RefreshFooter(
                        refreshing: view.$isLoadingMore,
                        action: { viewModel.input.loadMore() },
                        label: { ProgressView() }
                    )
                }
            }
        }

        var feedList: some View {
            Group {
                if !view.feedRowModels.isEmpty {
                    ScrollView {
                        feedRows
                    }
                    .enableRefresh()
                    .padding(.top, 16.0)
                } else {
                    Text(Localizable.feedsNoArticle())
                }
            }
        }
    }
}

// MARK: - Binding
extension FeedsView.Content {

    func binding() -> some View {
        onReceive(viewModel.output.didFinishRefresh) { _ in
            if view.isFirstLoad {
                view.isFirstLoad = false
            }

            view.isRefeshing = false
        }
        .onReceive(viewModel.output.didFinishLoadMore) {
            view.hasMore = $0
            view.isLoadingMore = false
        }
        .onReceive(viewModel.output.didFailToLoadArticle) { _ in
            view.isErrorToastPresented = true
        }
        .bind(viewModel.output.feedRowModels, to: view._feedRowModels)
    }
}

#if DEBUG
struct FeedsView_Previews: PreviewProvider {
    static var previews: some View { FeedsView() }
}
#endif
