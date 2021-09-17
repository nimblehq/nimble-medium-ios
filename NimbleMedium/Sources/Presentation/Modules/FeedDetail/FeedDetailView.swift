//
//  FeedDetailView.swift
//  NimbleMedium
//
//  Created by Mark G on 14/09/2021.
//

import SwiftUI
import SDWebImageSwiftUI
import Resolver
import ToastUI

struct FeedDetailView: View {

    @ObservedViewModel private var viewModel: FeedDetailViewModelProtocol

    @State private var articleTitle: String = ""
    @State private var articleBody: String = ""
    @State private var articleUpdatedAt: String = ""
    @State private var authorName: String = ""
    @State private var authorImage: URL?
    @State private var isErrorToastPresented = false
    @State private var isFetchArticleFailed = false
    @State private var isFetchArticleSuccess = false

    var body: some View {
        Content(view: self)
            .binding()
    }

    init(slug: String) {
        viewModel = Resolver.resolve(
            FeedDetailViewModelProtocol.self,
            args: slug
        )
    }
}

// MARK: - Content
private extension FeedDetailView {

    struct Content: View {

        let view: FeedDetailView
        var viewModel: FeedDetailViewModelProtocol { view.viewModel }

        // TODO: Update with real data in Integrate
        var body: some View {
            Group {
                if view.isFetchArticleSuccess {
                    articleDetail
                } else {
                    if view.isFetchArticleFailed {
                        Text(Localizable.feedDetailFetchFailureMessage())
                    } else { ProgressView() }
                }
            }
            .navigationTitle(Localizable.feedDetailTitle())
            .modifier(NavigationBarPrimaryStyle())
            .toast(isPresented: view.$isErrorToastPresented, dismissAfter: 3.0) {
                ToastView(Localizable.errorGeneric()) { } background: {
                    Color.clear
                }
            }
            .onAppear { viewModel.input.fetchArticle() }
        }

        var articleDetail: some View {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 16.0) {
                    Text(view.articleTitle)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.title)
                    author
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 16.0)
                .padding(.horizontal, 8.0)
                .background(Color(R.color.dark.name))

                Text(view.articleBody)
                    .padding(.horizontal, 8.0)

                AppMainButton(title: Localizable.feedsCommentsTitle()) {
                    // TODO: Go to Comments screen
                }
                .padding(.top, 16.0)
            }
        }

        var author: some View {
            AuthorView(
                articleUpdateAt: view.articleUpdatedAt,
                authorName: view.authorName,
                authorImage: view.authorImage
            )
            .authorNameColor(.white)
        }
    }
}

// MARK: - Binding
extension FeedDetailView.Content {

    func binding() -> some View {
        onReceive(viewModel.output.didFailToFetchArticle) { _ in
            view.isErrorToastPresented = true
            view.isFetchArticleFailed = true
        }
        .onReceive(viewModel.output.didFetchArticle) { _ in
            view.isFetchArticleSuccess = true
        }
        .bind(viewModel.output.articleTitle, to: view._articleTitle)
        .bind(viewModel.output.articleBody, to: view._articleBody)
        .bind(viewModel.output.articleUpdatedAt, to: view._articleUpdatedAt)
        .bind(viewModel.output.authorName, to: view._authorName)
        .bind(viewModel.output.authorImage, to: view._authorImage)
    }
}
