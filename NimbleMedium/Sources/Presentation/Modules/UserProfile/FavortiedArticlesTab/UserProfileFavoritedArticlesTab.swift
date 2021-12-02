//
//  UserProfileFavoritedArticlesTab.swift
//  NimbleMedium
//
//  Created by Mark G on 06/10/2021.
//

import PagerTabStripView
import SwiftUI
import ToastUI

struct UserProfileFavoritedArticlesTab: View {

    @ObservedViewModel private var viewModel: UserProfileFavoritedArticlesTabViewModelProtocol

    @State private var articleRowViewModels = [ArticleRowViewModelProtocol]()
    @State private var isErrorToastPresented = false
    @State private var isFavoritedArticlesFetched = false
    @State private var isFetchFavoritedArticlesFailed = false

    var body: some View {
        Group {
            if isFavoritedArticlesFetched {
                if articleRowViewModels.isEmpty {
                    Text(Localizable.feedsNoArticle())
                } else {
                    UserProfileArticleList(viewModels: articleRowViewModels)
                }
            } else {
                if isFetchFavoritedArticlesFailed {
                    Text(Localizable.feedsNoArticle())
                } else { ProgressView() }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .pagerTabItem {
            PagerTabItemTitle(Localizable.userProfileFavoritedArticlesTitle())
        }
        .toast(isPresented: $isErrorToastPresented, dismissAfter: 3.0) {
            ToastView(Localizable.errorGenericMessage()) {} background: {
                Color.clear
            }
        }
        .onReceive(viewModel.output.didFetchFavoritedArticles) { _ in
            isFavoritedArticlesFetched = true
        }
        .onReceive(viewModel.output.didFailToFetchFavoritedArticles) { _ in
            isErrorToastPresented = true
            isFetchFavoritedArticlesFailed = true
        }
        .bind(viewModel.output.articleRowVieModels, to: _articleRowViewModels)
        .onAppear { viewModel.input.fetchFavoritedArticles() }
    }

    init(viewModel: UserProfileFavoritedArticlesTabViewModelProtocol) {
        self.viewModel = viewModel
    }
}
