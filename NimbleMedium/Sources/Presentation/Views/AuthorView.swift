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
    private let articleUpdateAt: String
    private let authorName: String
    private let authorImage: URL?

    var body: some View {
        HStack {
            if let url = authorImage {
                // FIXME: It blocks UI
                WebImage(url: url)
                    .placeholder { defaultAvatar }
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
            } else {
                defaultAvatar
            }
            VStack(alignment: .leading) {
                NavigationLink(
                    destination: UserProfileView(username: authorName),
                    label: {
                        Text(authorName)
                            .foregroundColor(authorNameColor)
                    }
                )

                Text(articleUpdateAt)
                    .foregroundColor(.gray)
            }
        }
    }

    var defaultAvatar: some View {
        Image(R.image.defaultAvatar.name)
            .resizable()
            .frame(width: 50.0, height: 50.0)
    }

    init(
        articleUpdateAt: String,
        authorName: String,
        authorImage: URL?
    ) {
        self.init(
            articleUpdateAt: articleUpdateAt,
            authorName: authorName,
            authorNameColor: .black,
            authorImage: authorImage
        )
    }

    private init(
        articleUpdateAt: String,
        authorName: String,
        authorNameColor: Color,
        authorImage: URL?
    ) {
        self.articleUpdateAt = articleUpdateAt
        self.authorName = authorName
        self.authorNameColor = authorNameColor
        self.authorImage = authorImage
    }
}

// MARK: Style
extension AuthorView {

    // TODO: Find a better solution for the same result
    func authorNameColor(_ color: Color) -> Self {
        AuthorView(
            articleUpdateAt: articleUpdateAt,
            authorName: authorName,
            authorNameColor: color,
            authorImage: authorImage
        )
    }
}
