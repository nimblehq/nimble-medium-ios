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
    @State private var isErrorToastPresented = false
    @State private var isShowingCreateArticleScreen = false

    // TODO: Implement the logic when to show new article ToolbarItem button in integrate task, default to false
    @State private var isAuthenticated = false

    @Binding private var isSideMenuDraggingEnabled: Bool

    var body: some View {
        NavigationView {
            Group {
                if isFirstLoad {
                    ProgressView()
                } else {
                    FeedList(viewModel: viewModel)
                }
            }
            .navigationTitle(Localizable.feedsTitle())
            .modifier(NavigationBarPrimaryStyle(isBackButtonHidden: true))
            .toolbar {
                navigationBarLeadingContent
                navigationBarTrailingContent
            }
            .toast(isPresented: $isErrorToastPresented, dismissAfter: 3.0) {
                ToastView(Localizable.errorGeneric()) { } background: { Color.clear }
            }
            .onAppear { isSideMenuDraggingEnabled = true }
            .onDisappear { isSideMenuDraggingEnabled = false }
        }
        .accentColor(.white)
        .onReceive(viewModel.output.didFinishRefresh) { _ in if isFirstLoad { isFirstLoad = false } }
        .onReceive(viewModel.output.didFailToLoadArticle) { _ in isErrorToastPresented = true }
        .onAppear { viewModel.input.viewOnAppear() }
        .bind(viewModel.output.isAuthenticated, to: _isAuthenticated)
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

    init(isSideMenuDraggingEnabled: Binding<Bool>) {
        _isSideMenuDraggingEnabled = isSideMenuDraggingEnabled
    }
}

// MARK: FeedList
private extension FeedsView {

    struct FeedList: View {

        let viewModel: FeedsViewModelProtocol

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
                    RefreshHeader(
                        refreshing: $isRefeshing,
                        action: { viewModel.input.refresh() },
                        label: { _ in ProgressView() }
                    )

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
                .padding(.top, 16.0)
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
            .padding(.all, 16.0)
            .frame(maxWidth: .infinity, alignment: .leading)
        }

        var articleDetailNavigationLink: some View {
            NavigationLink(
                destination: ArticleDetailView(slug: activeDetailID),
                isActive: $isShowingFeedDetail,
                label: { EmptyView() }
            )
            .hidden()
        }
    }
}
#if DEBUG
struct FeedsView_Previews: PreviewProvider {
    static var previews: some View {
        FeedsView(isSideMenuDraggingEnabled: .constant(true))
    }
}
#endif
