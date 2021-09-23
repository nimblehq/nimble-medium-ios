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
    @State private var feedRowViewModels: [FeedRowViewModelProtocol] = []
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
        .bind(viewModel.output.feedRowViewModels, to: _feedRowViewModels)
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

            // FIXME: LazyVStack produces an infinity refresh FeedRow
            VStack(alignment: .leading) {
                ForEach(feedRowViewModels, id: \.output.id) { viewModel in
                    NavigationLink(
                        destination: FeedDetailView(slug: viewModel.output.id),
                        label: {
                            FeedRow(viewModel: viewModel)
                                .padding(.bottom, 16.0)
                        }
                    )
                }
            }
            .padding(.all, 16.0)
            .frame(maxWidth: .infinity, alignment: .leading)

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
            if !feedRowViewModels.isEmpty {
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
