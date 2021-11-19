//
//  FeedRow.swift
//  NimbleMedium
//
//  Created by Mark G on 01/09/2021.
//

import Resolver
import SDWebImageSwiftUI
import SwiftUI
import ToastUI

struct ArticleRow: View {

    @ObservedViewModel private var viewModel: ArticleRowViewModelProtocol

    @State var uiModel: UIModel?
    @State private var isErrorToastPresented = false

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
                        if uiModel.articleCanFavorite {
                            favouriteButton(uiModel: uiModel)
                        }
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
        .toast(isPresented: $isErrorToastPresented, dismissAfter: 3.0) {
            ToastView(Localizable.errorGenericMessage()) {} background: {
                Color.clear
            }
        }
        .bind(viewModel.output.uiModel, to: _uiModel)
        .onReceive(viewModel.output.didFailToToggleFavouriteArticle) {
            isErrorToastPresented = true
        }
    }

    init(viewModel: ArticleRowViewModelProtocol) {
        self.viewModel = viewModel
    }

    func favouriteButton(uiModel: UIModel) -> some View {
        FavouriteButton(
            count: uiModel.articleFavoriteCount,
            isSelected: uiModel.articleIsFavorited
        ) {
            viewModel.input.toggleFavouriteArticle()
        }
    }
}
