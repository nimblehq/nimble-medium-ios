//
//  FeedRow.swift
//  NimbleMedium
//
//  Created by Mark G on 01/09/2021.
//

import SwiftUI
import SDWebImageSwiftUI
import Resolver

struct FeedRow: View {

    @ObservedViewModel private var viewModel: FeedRowViewModelProtocol

    @State var uiModel: UIModel

    var body: some View {
        Content(view: self)
            .binding()
    }

    init(uiModel: UIModel) {
        _uiModel = State(initialValue: uiModel)
        viewModel = Resolver.resolve(
            FeedRowViewModelProtocol.self,
            args: uiModel
        )
    }
}

// MARK: - Content
private extension FeedRow {

    struct Content: View {

        let view: FeedRow
        var viewModel: FeedRowViewModelProtocol { view.viewModel }

        var body: some View {
            VStack(alignment: .leading, spacing: 16.0) {
                AuthorView(
                    articleUpdateAt: view.uiModel.articleUpdatedAt,
                    authorName: view.uiModel.authorName,
                    authorImage: view.uiModel.authorImage
                )
                VStack(alignment: .leading) {
                    Text(view.uiModel.articleTitle)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .foregroundColor(.black)
                    Text(view.uiModel.articleDescription)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

// MARK: - Binding
extension FeedRow.Content {

    func binding() -> some View {
        bind(viewModel.output.uiModel, to: view._uiModel)
    }
}
