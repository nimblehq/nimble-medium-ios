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
                author
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

        var author: some View {
            HStack {
                if let url = view.model.authorImage {
                    // FIXME: It blocks UI
                    WebImage(url: url)
                        .placeholder { defaultAvatar }
                        .resizable()
                        .frame(width: 50.0, height: 50.0)
                } else { defaultAvatar }
                VStack(alignment: .leading) {
                    Text(view.model.authorName)
                    Text(view.model.articleUpdatedAt)
                        .foregroundColor(.gray)
                }
            }
        }

        var defaultAvatar: some View {
            Image(R.image.defaultAvatar.name)
                .resizable()
                .frame(width: 50.0, height: 50.0)
        }
    }
}

// MARK: - Binding
extension FeedRow.Content {

    func binding() -> some View {
        bind(viewModel.output.model, to: view._model)
    }
}
