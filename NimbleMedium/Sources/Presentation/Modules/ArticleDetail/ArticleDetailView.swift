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

struct ArticleDetailView: View {

    @ObservedViewModel private var viewModel: ArticleDetailViewModelProtocol

    @State private var uiModel: UIModel?
    @State private var isErrorToastPresented = false
    @State private var isFetchArticleDetailFailed = false

    private let slug: String

    var body: some View {
        Group {
            if let uiModel = uiModel {
                articleDetail(uiModel: uiModel)
            } else {
                if isFetchArticleDetailFailed {
                    Text(Localizable.articleDetailFetchFailureMessage())
                } else { ProgressView() }
            }
        }
        .navigationTitle(Localizable.articleDetailTitleText())
        .modifier(NavigationBarPrimaryStyle())
        .toast(isPresented: $isErrorToastPresented, dismissAfter: 3.0) {
            ToastView(Localizable.errorGeneric()) { } background: {
                Color.clear
            }
        }
        .onAppear { viewModel.input.fetchArticleDetail() }
        .onReceive(viewModel.output.didFailToFetchArticleDetail) { _ in
            isErrorToastPresented = true
            isFetchArticleDetailFailed = true
        }
        .bind(viewModel.output.uiModel, to: _uiModel)
    }

    var comments: some View {
        NavigationLink(
            destination: ArticleCommentsView(id: viewModel.output.id),
            label: {
                Text(Localizable.articleDetailCommentsTitle())
                    .foregroundColor(.white)
                    .padding(.horizontal, 16.0)
                    .frame(height: 50.0)
                    .background(Color.green)
                    .cornerRadius(8.0)
            }
        )
        .padding(.all, 16.0)
    }

    init(slug: String) {
        self.slug = slug
        
        viewModel = Resolver.resolve(
            ArticleDetailViewModelProtocol.self,
            args: slug
        )
    }

    func articleDetail(uiModel: UIModel) -> some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 16.0) {
                Text(uiModel.articleTitle)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.title)
                author(uiModel: uiModel)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 16.0)
            .padding(.horizontal, 8.0)
            .background(Color(R.color.dark.name))

            Text(uiModel.articleBody)
                .padding(.horizontal, 8.0)

            comments
        }
    }

    func author(uiModel: UIModel) -> some View {
        AuthorView(
            articleUpdateAt: uiModel.articleUpdatedAt,
            authorName: uiModel.authorName,
            authorImage: uiModel.authorImage
        )
        .authorNameColor(.white)
    }

}
