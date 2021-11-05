//
//  FeedCommentRow.swift
//  NimbleMedium
//
//  Created by Mark G on 15/09/2021.
//

import SDWebImageSwiftUI
import SwiftUI
import ToastUI

struct ArticleCommentRow: View {

    @ObservedViewModel private var viewModel: ArticleCommentRowViewModelProtocol

    @State private var uiModel: UIModel?
    @State private var isLoadingToastPresented = false
    @State private var isErrorToastPresented = false

    var body: some View {
        Group {
            if let uiModel = uiModel {
                VStack(alignment: .leading, spacing: 0.0) {
                    Text(uiModel.commentBody)
                        .padding(.all, 16.0)
                    Divider()
                        .frame(maxWidth: .infinity)
                        .background(Color(R.color.semiLightGray.name))
                    author(uiModel: uiModel)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(
                    RoundedRectangle(cornerRadius: 8.0)
                        .stroke(
                            Color(R.color.semiLightGray.name),
                            lineWidth: 1.0
                        )
                )
            } else {
                EmptyView()
            }
        }
        .bind(viewModel.output.uiModel, to: _uiModel)
        .bind(viewModel.output.isLoading, to: _isLoadingToastPresented)
        .onReceive(viewModel.output.didFailToDeleteComment) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isErrorToastPresented = true
            }
        }
        .toast(isPresented: $isErrorToastPresented, dismissAfter: 3.0) {
            ToastView(Localizable.errorGeneric()) {} background: {
                Color.clear
            }
        }
        .toast(isPresented: $isLoadingToastPresented) {
            ToastView(String.empty) {}
                .toastViewStyle(IndefiniteProgressToastViewStyle())
        }
    }

    init(viewModel: ArticleCommentRowViewModelProtocol) {
        self.viewModel = viewModel
    }

    func author(uiModel: UIModel) -> some View {
        HStack {
            AvatarView(url: uiModel.authorImage)
                .size(25.0)
            Text(uiModel.authorName)
                .foregroundColor(.green)
            Text(uiModel.commentUpdatedAt)
                .foregroundColor(.gray)
            if uiModel.isAuthor {
                Spacer()
                Button(
                    action: { viewModel.input.deleteComment() },
                    label: { Image(systemName: SystemImageName.trashFill.rawValue) }
                )
                .foregroundColor(.black)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.all, 16.0)
        .background(Color(R.color.lightGray.name))
    }
}
