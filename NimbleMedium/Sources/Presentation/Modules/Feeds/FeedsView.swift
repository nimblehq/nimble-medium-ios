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
    @State private var feedRowUIModels: [FeedRow.UIModel] = []
    @State private var isErrorToastPresented = false

    var body: some View {
        NavigationView {
            Group {
                if isFirstLoad {
                    ProgressView()
                } else {
                    feedList
                }
            }
            .navigationTitle(Localizable.feedsTitle())
            .modifier(NavigationBarPrimaryStyle(isBackButtonHidden: true))
            .toolbar { navigationBarLeadingContent }
            .toast(isPresented: $isErrorToastPresented, dismissAfter: 3.0) {
                ToastView(Localizable.errorGeneric()) { } background: {
                    Color.clear
                }
            }
        }
        .accentColor(.white)
        .onReceive(viewModel.output.didFinishRefresh) { _ in
            if isFirstLoad {
                isFirstLoad = false
            }

            isRefeshing = false
        }
        .onReceive(viewModel.output.didFinishLoadMore) {
            hasMore = $0
            isLoadingMore = false
        }
        .onReceive(viewModel.output.didFailToLoadArticle) { _ in
            isErrorToastPresented = true
        }
        .bind(viewModel.output.feedRowModels, to: _feedRowUIModels)
        .onAppear { viewModel.input.refresh() }
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
                refreshing: $isRefeshing,
                action: { viewModel.input.refresh() },
                label: { _ in ProgressView() }
            )

            LazyVStack(alignment: .leading) {
                ForEach(feedRowUIModels, id: \.id) { uiModel in
                    NavigationLink(
                        destination: FeedDetailView(slug: uiModel.id),
                        label: {
                            FeedRow(uiModel: uiModel)
                                .padding(.bottom, 16.0)
                        }
                    )
                }
            }
            .padding(.all, 16.0)

            if hasMore {
                RefreshFooter(
                    refreshing: $isLoadingMore,
                    action: { viewModel.input.loadMore() },
                    label: { ProgressView() }
                )
            }
        }
    }

    var feedList: some View {
        Group {
            if !feedRowUIModels.isEmpty {
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

#if DEBUG
struct FeedsView_Previews: PreviewProvider {
    static var previews: some View { FeedsView() }
}
#endif
