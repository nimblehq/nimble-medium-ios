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
            .toolbar { navigationBarLeadingContent }
            .toast(isPresented: $isErrorToastPresented, dismissAfter: 3.0) {
                ToastView(Localizable.errorGeneric()) { } background: {
                    Color.clear
                }
            }
            .onAppear {
                isSideMenuDraggingEnabled = true
            }
            .onDisappear {
                isSideMenuDraggingEnabled = false
            }
        }
        .accentColor(.white)
        .onReceive(viewModel.output.didFinishRefresh) { _ in
            if isFirstLoad {
                isFirstLoad = false
            }
        }
        .onReceive(viewModel.output.didFailToLoadArticle) { _ in
            isErrorToastPresented = true
        }
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

    init(isSideMenuDraggingEnabled: Binding<Bool>) {
        _isSideMenuDraggingEnabled = isSideMenuDraggingEnabled
    }
}

// MARK: FeedList
private extension FeedsView {

    struct FeedList: View, Equatable {

        let viewModel: FeedsViewModelProtocol

        @State var isRefeshing: Bool = false
        @State var hasMore: Bool = true
        @State var isLoadingMore: Bool = false
        @State var feedRowViewModels: [FeedRowViewModelProtocol] = []
        @State var isShowingFeedDetail = false
        @State var activeDetailID = ""

        var body: some View {
            Group {
                if !feedRowViewModels.isEmpty {
                    ScrollView { feedRows }
                    .enableRefresh()
                    .padding(.top, 16.0)
                } else {
                    Text(Localizable.feedsNoArticle())
                }
            }
            .onReceive(viewModel.output.didFinishRefresh) { _ in
                isRefeshing = false
            }
            .onReceive(viewModel.output.didFinishLoadMore) {
                hasMore = $0
                isLoadingMore = false
            }
            .bind(viewModel.output.feedRowViewModels, to: _feedRowViewModels)
        }

        var feedRows: some View {
            Group {
                feedDetailNavigationLink
                RefreshHeader(
                    refreshing: $isRefeshing,
                    action: { viewModel.input.refresh() },
                    label: { _ in ProgressView() }
                )

                // FIXME: LazyVStack produces an infinity refresh FeedRow
                ForEach(feedRowViewModels, id: \.output.id) { viewModel in
                    FeedRow(viewModel: viewModel)
                        .padding(.bottom, 16.0)
                        .onTapGesture {
                            activeDetailID = viewModel.output.id
                            isShowingFeedDetail = true
                        }
                }
                .padding(.all, 16.0)
                .frame(maxWidth: .infinity, alignment: .leading)

                if !isShowingFeedDetail && hasMore {
                    RefreshFooter(
                        refreshing: $isLoadingMore,
                        action: { viewModel.input.loadMore() },
                        label: { ProgressView() }
                    )
                }
            }
        }

        var feedDetailNavigationLink: some View {
            NavigationLink(
                destination: FeedDetailView(slug: activeDetailID),
                isActive: $isShowingFeedDetail,
                label: { EmptyView() }
            )
            .hidden()
        }

        static func == (lhs: FeedsView.FeedList, rhs: FeedsView.FeedList) -> Bool {
            lhs.feedRowViewModels.count != rhs.feedRowViewModels.count
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
