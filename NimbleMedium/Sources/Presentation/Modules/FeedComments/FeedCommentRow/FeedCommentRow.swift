//
//  FeedCommentRow.swift
//  NimbleMedium
//
//  Created by Mark G on 15/09/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct FeedCommentRow: View {

    @ObservedViewModel private var viewModel: FeedCommentRowViewModelProtocol

    @State var uiModel: UIModel?

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
        .onReceive(viewModel.output.uiModel) {
            uiModel = $0
        }
    }

    var defaultAvatar: some View {
        Image(R.image.defaultAvatar.name)
            .resizable()
            .frame(width: 25.0, height: 25.0)
    }

    init(viewModel: FeedCommentRowViewModelProtocol) {
        self.viewModel = viewModel
    }

    func author(uiModel: UIModel) -> some View {
        HStack {
            if let url = uiModel.authorImage {
                // FIXME: It blocks UI
                WebImage(url: url)
                    .placeholder { defaultAvatar }
                    .resizable()
                    .frame(width: 25.0, height: 25.0)
            } else {
                defaultAvatar
            }
            Text(uiModel.authorName)
                .foregroundColor(.green)
            Text(uiModel.commentUpdatedAt)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.all, 16.0)
        .background(Color(R.color.lightGray.name))
    }
}
