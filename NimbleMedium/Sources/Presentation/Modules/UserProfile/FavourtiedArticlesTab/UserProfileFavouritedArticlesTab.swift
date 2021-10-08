//
//  UserProfileFavouritedArticlesTab.swift
//  NimbleMedium
//
//  Created by Mark G on 06/10/2021.
//

import SwiftUI
import PagerTabStripView
import ToastUI

struct UserProfileFavouritedArticlesTab: View {

    @ObservedViewModel private var viewModel: UserProfileFavouritedArticlesTabViewModelProtocol

    @State private var articleRowViewModels = [ArticleRowViewModelProtocol]()
    @State private var isErrorToastPresented = false
    @State private var isFavouritedArticlesFetched = false
    @State private var isFetchFavouritedArticlesFailed = false

    var body: some View {
        Group {
            if isFavouritedArticlesFetched {
                UserProfileArticleList(viewModels: articleRowViewModels)
            } else {
                if isFetchFavouritedArticlesFailed {
                    Text(Localizable.feedsNoArticle())
                } else { ProgressView() }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .pagerTabItem {
            UserProfileView.TabItemTitle(Localizable.userProfileFavouritedArticlesTitle())
        }
        .toast(isPresented: $isErrorToastPresented, dismissAfter: 3.0) {
            ToastView(Localizable.errorGeneric()) { } background: {
                Color.clear
            }
        }
        .onReceive(viewModel.output.didFetchFavouritedArticles) { _ in
            isFavouritedArticlesFetched = true
        }
        .onReceive(viewModel.output.didFailToFetchFavouritedArticles) { _ in
            isErrorToastPresented = true
            isFetchFavouritedArticlesFailed = true
        }
        .bind(viewModel.output.articleRowVieModels, to: _articleRowViewModels)
        .onAppear { viewModel.input.fetchFavouritedArticles() }
    }

    init(viewModel: UserProfileFavouritedArticlesTabViewModelProtocol) {
        self.viewModel = viewModel
    }
}
