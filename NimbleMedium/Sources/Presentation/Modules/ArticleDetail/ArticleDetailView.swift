//
//  FeedDetailView.swift
//  NimbleMedium
//
//  Created by Mark G on 14/09/2021.
//

import Resolver
import SDWebImageSwiftUI
import SwiftUI
import ToastUI

struct ArticleDetailView: View {

    @ObservedViewModel private var viewModel: ArticleDetailViewModelProtocol

    @State private var uiModel: UIModel?
    @State private var isErrorToastPresented = false
    @State private var isLoadingToastPresented = false
    @State private var isFetchArticleDetailFailed = false
    @State private var isArticleAuthor = false

    // swiftlint:disable identifier_name
    @State private var isDeleteArticleConfirmationAlertPresented = false

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

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
        .toolbar { navigationBarTrailingContent }
        .modifier(NavigationBarPrimaryStyle())
        .toast(isPresented: $isErrorToastPresented, dismissAfter: 3.0) {
            ToastView(Localizable.errorGeneric()) {} background: {
                Color.clear
            }
        }
        .onAppear { viewModel.input.fetchArticleDetail() }
        .onReceive(viewModel.output.didFailToFetchArticleDetail) { _ in
            isErrorToastPresented = true
            isFetchArticleDetailFailed = true
        }
        .onReceive(viewModel.output.didFailToToggleFollow) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isErrorToastPresented = true
            }
        }
        .onReceive(viewModel.output.didDeleteArticle) { _ in
            presentationMode.wrappedValue.dismiss()
        }
        .onReceive(viewModel.output.didFailToDeleteArticle) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isErrorToastPresented = true
            }
        }
        .bind(viewModel.output.isLoading, to: _isLoadingToastPresented)
        .bind(viewModel.output.uiModel, to: _uiModel)
        .bind(viewModel.output.isArticleAuthor, to: _isArticleAuthor)
        .alert(isPresented: $isDeleteArticleConfirmationAlertPresented) {
            Alert(
                title: Text(Localizable.popupConfirmDeleteArticleTitle()),
                primaryButton: .destructive(
                    Text(Localizable.actionConfirmText()),
                    action: {
                        isLoadingToastPresented = true
                        viewModel.input.deleteArticle()
                    }
                ),
                secondaryButton: .default(Text(Localizable.actionCancelText()))
            )
        }
        .toast(isPresented: $isLoadingToastPresented) {
            ToastView(String.empty) {}
                .toastViewStyle(IndefiniteProgressToastViewStyle())
        }
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

    var navigationBarTrailingContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if isArticleAuthor {
                Button(
                    action: { isDeleteArticleConfirmationAlertPresented = true },
                    label: { Image(systemName: SystemImageName.minusSquare.rawValue) }
                )
            }
        }
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
                HStack {
                    author(uiModel: uiModel)
                    Spacer()

                    FollowButton(isSelected: uiModel.authorIsFollowing) {
                        viewModel.input.toggleFollowUser()
                    }
                }
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
