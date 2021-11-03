//
//  FeedCommentRow.swift
//  NimbleMedium
//
//  Created by Mark G on 15/09/2021.
//

import SDWebImageSwiftUI
import SwiftUI

struct ArticleCommentRow: View {

    @ObservedViewModel private var viewModel: ArticleCommentRowViewModelProtocol

    // TODO: Update to correct value in integrate task, default to hide the delete button for now
    @State var isMyComment: Bool = false
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
            if isMyComment {
                Spacer()
                Button(
                    action: {
                        // TODO: Handle delete comment in integrate task
                    },
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
