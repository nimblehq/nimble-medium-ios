//
//  UserProfileView+ArticleList.swift
//  NimbleMedium
//
//  Created by Mark G on 29/09/2021.
//

import SwiftUI

extension UserProfileView {

    struct ArticleList: View {

        var body: some View {
            ScrollView {
                VStack {
                    // TODO: Update with real data
                    ForEach(1...10, id: \.self) { _ in
                        ArticleRow(viewModel: ArticleRowViewModel(article: DummyArticle()))
                            .padding(.bottom, 16.0)
                    }
                }
                .padding(.all, 16.0)
            }
        }
    }

    // TODO: Remove when integrating
    private struct DummyArticle: Article {

        var slug: String = "slug"

        var title: String = "title"

        var description: String = "description"

        var body: String = "body"

        var tagList: [String] = []

        var createdAt: Date = Date()

        var updatedAt: Date = Date()

        var favorited: Bool = true

        var favoritesCount: Int = 0

        var author: Profile = DummyProfile()
    }

    private struct DummyProfile: Profile {

        var username: String = "username"

        var bio: String? = "bio"

        var image: String?

        var following: Bool = true
    }
}
