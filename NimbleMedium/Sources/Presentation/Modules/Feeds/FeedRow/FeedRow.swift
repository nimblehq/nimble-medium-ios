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

    @State var model: Model

    var body: some View {
        Content(view: self)
            .binding()
    }

    init(model: Model) {
        _model = State(initialValue: model)
        viewModel = Resolver.resolve(
            FeedRowViewModelProtocol.self,
            args: model
        )
    }
}

// MARK: - Content
private extension FeedRow {

    struct Content: View {

        let view: FeedRow
        var viewModel: FeedRowViewModelProtocol { view.viewModel }

        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                AuthorView(
                    articleUpdateAt: view.updatedAt,
                    authorName: view.authorName,
                    authorImage: view.authorImage
                )
                VStack(alignment: .leading) {
                    Text(view.model.articleTitle)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text(view.model.articleDescription)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

// MARK: - Binding
extension FeedRow.Content {

    func binding() -> some View {
        bind(viewModel.output.model, to: view._model)
    }
}
