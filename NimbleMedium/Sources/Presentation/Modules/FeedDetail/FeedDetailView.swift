//
//  FeedDetailView.swift
//  NimbleMedium
//
//  Created by Mark G on 14/09/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct FeedDetailView: View {

    @ObservedViewModel private var viewModel: FeedDetailViewModelProtocol

    @State private var article: Article?
    @State private var isErrorToastPresented = false
    @State private var isFetchArticleFailed = false

    var body: some View {
        Content(view: self)
            .binding()
    }

    init(viewModel: FeedDetailViewModelProtocol) {
        self.viewModel = viewModel
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
                if let article = view.article {
                    articleDetail(article)
                } else {
                    if view.isFetchArticleFailed {
                        Text(Localizable.feedDetaulFetchFailureMessage())
                    } else { ProgressView() }
                }
            }
            .navigationTitle(Localizable.feedDetailTitle())
            .modifier(NavigationBarPrimaryStyle())
            .onAppear { viewModel.input.fetchArticle() }
        }

        func articleDetail(_ article: Article) -> some View {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 16.0) {
                    Text(article.title)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.title)
                    author
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 16.0)
                .padding(.horizontal, 8.0)
                .background(Color(R.color.dark.name))

                Text(article.body)
                    .padding(.horizontal, 8.0)

                AppMainButton(title: Localizable.feedsCommentsTitle()) {
                    // TODO: Go to Comments screen
                }
                .padding(.top, 16.0)
            }
        }

        var author: some View {
            AuthorView(
                articleUpdateAt: "May 02, 1991",
                authorName: "Mark",
                authorImage: nil
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
        .bind(viewModel.output.article, to: view._article)
    }
}
