//
//  FeedCommentsView.swift
//  NimbleMedium
//
//  Created by Mark G on 15/09/2021.
//

import SwiftUI
import Resolver
import ToastUI

struct FeedCommentsView: View {

    @ObservedViewModel private var viewModel: FeedCommentsViewModelProtocol

    @State var feedCommentRowViewModels: [FeedCommentRowViewModelProtocol]?
    @State private var isErrorToastPresented = false
    @State private var isFetching = true
    @State private var isFetchCommentsFailed = false

    var body: some View {
        Group {
            if !isFetching, let viewModels = feedCommentRowViewModels {
                if !viewModels.isEmpty {
                    ScrollView(.vertical) {
                        LazyVStack(alignment: .leading, spacing: 12.0) {
                            ForEach(viewModels, id: \.output.id) {
                                FeedCommentRow(viewModel: $0)
                            }
                        }
                        .padding(.all, 16.0)
                    }
                } else {
                    Text(Localizable.feedCommentsNoCommentMessage())
                }
            } else {
                if isFetchCommentsFailed {
                    Text(Localizable.feedCommentsNoCommentMessage())
                } else { ProgressView() }
            }
        }
        .toast(isPresented: $isErrorToastPresented, dismissAfter: 3.0) {
            ToastView(Localizable.errorGeneric()) { } background: {
                Color.clear
            }
        }
        .navigationTitle(Localizable.feedCommentsTitle())
        .modifier(NavigationBarPrimaryStyle())
        .onReceive(viewModel.output.didFailToFetchComments) { _ in
            isFetching = false
            isErrorToastPresented = true
            isFetchCommentsFailed = true
        }
        .onReceive(viewModel.output.didFetchComments) {
            isFetching = false
        }
        .onReceive(viewModel.output.feedCommentRowViewModels) {
            feedCommentRowViewModels = $0
        }
        .onAppear { viewModel.input.fetchComments() }
    }

    init(id: String) {
        viewModel = Resolver.resolve(
            FeedCommentsViewModelProtocol.self,
            args: id
        )
    }
}
