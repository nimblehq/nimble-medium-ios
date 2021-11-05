//
//  FeedCommentsView.swift
//  NimbleMedium
//
//  Created by Mark G on 15/09/2021.
//

import Resolver
import SwiftUI
import ToastUI

struct ArticleCommentsView: View {

    @ObservedViewModel private var viewModel: ArticleCommentsViewModelProtocol

    @State private var articleCommentRowViewModels: [ArticleCommentRowViewModelProtocol]?
    @State private var isErrorToastPresented = false
    @State private var isFetchingArticleComments = true
    @State private var isFetchArticleCommentsFailed = false
    @State private var commentContent: String = ""

    var body: some View {
        VStack {
            comments
            Spacer()
            HStack {
                AppTextView(
                    placeholder: Localizable.feedCommentsCommentTextViewPlaceholder(),
                    text: $commentContent
                )
                Button {
                    // TODO: Integrate send comment
                } label: {
                    Image(systemName: SystemImageName.arrowshapeTurnUpForwardCircleFill.rawValue)
                        .foregroundColor(.black)
                }
            }
            .frame(height: 50)
            .padding(.horizontal, 20.0)
        }
        .toast(isPresented: $isErrorToastPresented, dismissAfter: 3.0) {
            ToastView(Localizable.errorGeneric()) {} background: {
                Color.clear
            }
        }
        .navigationTitle(Localizable.feedCommentsTitle())
        .modifier(NavigationBarPrimaryStyle())
        .onReceive(viewModel.output.didFailToFetchArticleComments) { _ in
            isFetchingArticleComments = false
            isErrorToastPresented = true
            isFetchArticleCommentsFailed = true
        }
        .onReceive(viewModel.output.didFetchArticleComments) {
            isFetchingArticleComments = false
        }
        .onReceive(viewModel.output.articleCommentRowViewModels) {
            articleCommentRowViewModels = $0
        }
        .onAppear { viewModel.input.fetchArticleComments() }
    }

    var comments: some View {
        Group {
            if !isFetchingArticleComments, let viewModels = articleCommentRowViewModels {
                if !viewModels.isEmpty {
                    ScrollView(.vertical) {
                        LazyVStack(alignment: .leading, spacing: 12.0) {
                            ForEach(viewModels, id: \.output.id) {
                                ArticleCommentRow(viewModel: $0)
                            }
                        }
                        .padding(.all, 16.0)
                    }
                } else {
                    Text(Localizable.feedCommentsNoCommentMessage())
                }
            } else {
                if isFetchArticleCommentsFailed {
                    Text(Localizable.feedCommentsNoCommentMessage())
                } else { ProgressView() }
            }
        }
        .frame(maxHeight: .infinity)
    }

    init(id: String) {
        viewModel = Resolver.resolve(
            ArticleCommentsViewModelProtocol.self,
            args: id
        )
    }
}
