//
//  FeedsTabView.swift
//  NimbleMedium
//
//  Created by Mark G on 11/08/2021.
//

import PagerTabStripView
import Refresh
import Resolver
import SwiftUI
import ToastUI

struct FeedsTabView: View {

    @ObservedViewModel private var viewModel: FeedsTabViewModelProtocol

    @State private var isFirstLoad: Bool = true
    @State private var isErrorToastPresented = false
    @State private var tabType = TabType.yourFeeds

    var body: some View {
        Group {
            if isFirstLoad {
                ProgressView()
            } else {
                FeedList(viewModel: viewModel)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toast(isPresented: $isErrorToastPresented, dismissAfter: 3.0) {
            ToastView(Localizable.errorGenericMessage()) {} background: { Color.clear }
        }
        .onReceive(viewModel.output.didFinishRefresh) { _ in if isFirstLoad { isFirstLoad = false } }
        .onReceive(viewModel.output.didFailToLoadArticle) { _ in isErrorToastPresented = true }
        .bind(viewModel.output.tabType, to: _tabType)
        .onAppear {
            guard isFirstLoad else { return }
            viewModel.input.refresh()
        }
    }

    init(viewModel: FeedsTabViewModelProtocol) {
        self.viewModel = viewModel
    }
}

// MARK: FeedList

extension FeedsTabView {

    private struct FeedList: View {

        let viewModel: FeedsTabViewModelProtocol

        @State var isRefeshing: Bool = false
        @State var hasMore: Bool = true
        @State var isLoadingMore: Bool = false
        @State var articleRowViewModels: [ArticleRowViewModelProtocol] = []
        @State var isShowingFeedDetail = false
        @State var activeDetailID = ""

        var body: some View {
            GeometryReader { geometry in
                ScrollView {
                    articleDetailNavigationLink
                    refreshHeader
                    if !articleRowViewModels.isEmpty {
                        articleRows
                        if !isShowingFeedDetail && hasMore {
                            RefreshFooter(
                                refreshing: $isLoadingMore,
                                action: { viewModel.input.loadMore() },
                                label: { ProgressView() }
                            )
                        }
                    } else {
                        Text(Localizable.feedsNoArticle())
                            .frame(minHeight: geometry.size.height)
                    }
                }
                .enableRefresh()
                .padding(.top, 24.0)
                .clipped(antialiased: false)
                .frame(maxHeight: .infinity)
            }
            .onReceive(viewModel.output.didFinishRefresh) { _ in
                isRefeshing = false
            }
            .onReceive(viewModel.output.didFinishLoadMore) {
                hasMore = $0
                isLoadingMore = false
            }
            .bind(viewModel.output.articleRowViewModels, to: _articleRowViewModels)
        }

        var articleRows: some View {
            // FIXME: LazyVStack produces an infinity refresh FeedRow
            ForEach(articleRowViewModels, id: \.output.id) { viewModel in
                ArticleRow(viewModel: viewModel)
                    .padding(.bottom, 16.0)
                    .onTapGesture {
                        activeDetailID = viewModel.output.id
                        isShowingFeedDetail = true
                    }
            }
            .padding(.horizontal, 16.0)
            .frame(maxWidth: .infinity, alignment: .leading)
        }

        var articleDetailNavigationLink: some View {
            Group {
                if !activeDetailID.isEmpty {
                    NavigationLink(
                        destination: ArticleDetailView(slug: activeDetailID),
                        isActive: $isShowingFeedDetail,
                        label: { EmptyView() }
                    )
                    .hidden()
                } else { EmptyView() }
            }
        }

        var refreshHeader: some View {
            RefreshHeader(
                refreshing: $isRefeshing,
                action: { viewModel.input.refresh() },
                label: { _ in
                    ZStack {
                        ProgressView()
                            .offset(y: -10.0)
                    }
                }
            )
        }
    }
}

extension FeedsTabView {

    enum TabType {
        case yourFeeds
        case globalFeeds
    }
}

#if DEBUG
    struct FeedsTabView_Previews: PreviewProvider {
        static var previews: some View {
            FeedsTabView(viewModel: Resolver.resolve())
        }
    }
#endif
