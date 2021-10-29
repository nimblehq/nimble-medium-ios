//
//  FeedRow.swift
//  NimbleMedium
//
//  Created by Mark G on 01/09/2021.
//

import Resolver
import SDWebImageSwiftUI
import SwiftUI

struct ArticleRow: View {

    @ObservedViewModel private var viewModel: ArticleRowViewModelProtocol

    @State var uiModel: UIModel?

    var body: some View {
        Group {
            if let uiModel = uiModel {
                VStack(alignment: .leading, spacing: 16.0) {
                    HStack(alignment: .top) {
                        AuthorView(
                            articleUpdateAt: uiModel.articleUpdatedAt,
                            authorName: uiModel.authorName,
                            authorImage: uiModel.authorImage
                        )
                        Spacer()
                        // TODO: Update favourite state & action
                        FavouriteButton(count: 0, isSelected: false) {}
                    }
                    VStack(alignment: .leading) {
                        Text(uiModel.articleTitle)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .foregroundColor(.black)
                        Text(uiModel.articleDescription)
                            .foregroundColor(.gray)
                    }
                }
            } else {
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onReceive(viewModel.output.uiModel) {
            uiModel = $0
        }
    }

    init(viewModel: ArticleRowViewModelProtocol) {
        self.viewModel = viewModel
    }
}
