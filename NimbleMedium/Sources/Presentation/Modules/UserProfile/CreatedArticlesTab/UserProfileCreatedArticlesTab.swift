//
//  UserProfileCreatedArticlesTab.swift
//  NimbleMedium
//
//  Created by Mark G on 06/10/2021.
//

import PagerTabStripView
import SwiftUI
import ToastUI

struct UserProfileCreatedArticlesTab: View {

    @ObservedViewModel private var viewModel: UserProfileCreatedArticlesTabViewModelProtocol

    @State private var articleRowViewModels = [ArticleRowViewModelProtocol]()
    @State private var isErrorToastPresented = false
    @State private var isCreatedArticlesFetched = false
    @State private var isFetchCreatedArticlesFailed = false

    var body: some View {
        Group {
            if isCreatedArticlesFetched {
                UserProfileArticleList(viewModels: articleRowViewModels)
            } else {
                if isFetchCreatedArticlesFailed {
                    Text(Localizable.feedsNoArticle())
                } else { ProgressView() }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .pagerTabItem {
            PagerTabItemTitle(Localizable.userProfileCreatedArticlesTitle())
        }
        .toast(isPresented: $isErrorToastPresented, dismissAfter: 3.0) {
            ToastView(Localizable.errorGeneric()) {} background: {
                Color.clear
            }
        }
        .onReceive(viewModel.output.didFetchCreatedArticles) { _ in
            isCreatedArticlesFetched = true
        }
        .onReceive(viewModel.output.didFailToFetchCreatedArticles) { _ in
            isErrorToastPresented = true
            isFetchCreatedArticlesFailed = true
        }
        .bind(viewModel.output.articleRowVieModels, to: _articleRowViewModels)
        .onAppear { viewModel.input.fetchCreatedArticles() }
    }

    init(viewModel: UserProfileCreatedArticlesTabViewModelProtocol) {
        self.viewModel = viewModel
    }
}
