//
//  AuthorView.swift
//  NimbleMedium
//
//  Created by Mark G on 14/09/2021.
//

import SDWebImageSwiftUI
import SwiftUI

struct AuthorView: View {

    private var authorNameColor: Color = .black
    private let articleUpdateAt: String
    private let authorName: String
    private let authorImage: URL?

    var body: some View {
        HStack {
            AvatarView(url: authorImage)
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

    init(
        articleUpdateAt: String,
        authorName: String,
        authorImage: URL?
    ) {
        self.articleUpdateAt = articleUpdateAt
        self.authorName = authorName
        self.authorImage = authorImage
    }
}

// MARK: Style

extension AuthorView {

    func authorNameColor(_ color: Color) -> Self {
        var view = self
        view.authorNameColor = color
        return view
    }
}
