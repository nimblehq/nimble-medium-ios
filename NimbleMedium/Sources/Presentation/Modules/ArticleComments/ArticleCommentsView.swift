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

    @EnvironmentObject private var userSessionViewModel: UserSessionViewModel

    @State private var articleCommentRowViewModels: [ArticleCommentRowViewModelProtocol]?
    @State private var isErrorToastPresented = false
    @State private var isFetchingArticleComments = true
    @State private var isFetchArticleCommentsFailed = false
    @State private var commentContent: String = ""
    @State private var isCreateCommentEnabled = false
    @State private var isAuthenticated = false
    @State private var shouldCommentContentInputEndEditing = false

    private var isPostCommentButtonEnabled: Bool {
        isCreateCommentEnabled && !commentContent.isEmpty
    }

    var body: some View {
        VStack {
            commentsView
            if isAuthenticated {
                Spacer()
                commentInput
            }
        }
        .onTapGesture {
            shouldCommentContentInputEndEditing = true
            hideKeyboard()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                shouldCommentContentInputEndEditing = false
            }
        }
        .toast(isPresented: $isErrorToastPresented, dismissAfter: 3.0) {
            ToastView(Localizable.errorGenericMessage()) {} background: {
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
        .onReceive(viewModel.output.didFailToCreateArticleComment) { _ in
            isErrorToastPresented = true
        }
        .onReceive(viewModel.output.didFetchArticleComments) {
            isFetchingArticleComments = false
        }
        .onReceive(viewModel.output.didCreateArticleComment) {
            commentContent = ""
        }
        .onReceive(viewModel.output.articleCommentRowViewModels) {
            articleCommentRowViewModels = $0
        }
        .bind(viewModel.output.isCreateCommentEnabled, to: _isCreateCommentEnabled)
        .bind(userSessionViewModel.output.isAuthenticated, to: _isAuthenticated)
        .onAppear { viewModel.input.fetchArticleComments() }
    }

    var commentsView: some View {
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

    var commentInput: some View {
        HStack {
            AppTextView(
                placeholder: Localizable.feedCommentsCommentTextViewPlaceholder(),
                text: $commentContent
            )
            .shouldEndEditing(shouldCommentContentInputEndEditing)
            .disabled(!isCreateCommentEnabled)
            Button {
                viewModel.input.createArticleComment(content: commentContent)
            } label: {
                Image(systemName: SystemImageName.arrowshapeTurnUpForwardCircleFill.rawValue)
                    .foregroundColor(isPostCommentButtonEnabled ? .black : .gray)
            }
            .disabled(!isPostCommentButtonEnabled)
        }
        .frame(height: 50)
        .padding(.horizontal, 20.0)
    }

    init(id: String) {
        viewModel = Resolver.resolve(
            ArticleCommentsViewModelProtocol.self,
            args: id
        )
    }
}
