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

    @State var articleTitle: String = ""
    @State var articleDescription: String = ""
    @State var authorImage: URL?
    @State var authorName: String = ""
    @State var updatedAt: String = ""

    var body: some View {
        Content(view: self)
            .binding()
    }

    init(viewModel: FeedRowViewModelProtocol) {
        self.viewModel = viewModel
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
                    Text(view.articleTitle)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text(view.articleDescription)
                        .foregroundColor(.gray)
                }
            }
        }

        var author: some View {
            HStack {
                if let url = view.authorImage {
                    // FIXME: It blocks UI
                    WebImage(url: url)
                        .placeholder { defaultAvatar }
                        .resizable()
                        .frame(width: 50.0, height: 50.0)
                } else { defaultAvatar }
                VStack(alignment: .leading) {
                    Text(view.authorName)
                    Text(view.updatedAt)
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
        bind(viewModel.output.articleTitle, to: view._articleTitle)
            .bind(viewModel.output.articleDescription, to: view._articleDescription)
            .bind(viewModel.output.authorName, to: view._authorName)
            .bind(viewModel.output.authorImage, to: view._authorImage)
            .bind(viewModel.output.updatedAt, to: view._updatedAt)
    }
}
