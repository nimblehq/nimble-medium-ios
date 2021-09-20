//
//  AuthorView.swift
//  NimbleMedium
//
//  Created by Mark G on 14/09/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct AuthorView: View {

    private let authorNameColor: Color?
    private let article: Article

    var body: some View {
        HStack {
            if let url = try? article.author.image?.asURL() {
                // FIXME: It blocks UI
                WebImage(url: url)
                    .placeholder { defaultAvatar }
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
            } else {
                defaultAvatar
            }
            VStack(alignment: .leading) {
                Text(article.author.username)
                    .foregroundColor(authorNameColor)
                Text(article.updatedAt.format(Constants.Article.dateFormat))
                    .foregroundColor(.gray)
            }
        }
    }

    var defaultAvatar: some View {
        Image(R.image.defaultAvatar.name)
            .resizable()
            .frame(width: 50.0, height: 50.0)
    }

    init(article: Article) {
        self.init(article: article, authorNameColor: nil)
    }

    private init(article: Article, authorNameColor: Color?) {
        self.authorNameColor = authorNameColor
        self.article = article
    }
}

// MARK: Style
extension AuthorView {

    // TODO: Find a better solution for the same result
    func authorNameColor(_ color: Color? = .black) -> Self {
        AuthorView(article: article, authorNameColor: color)
    }
}
