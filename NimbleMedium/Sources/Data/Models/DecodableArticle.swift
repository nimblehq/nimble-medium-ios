//
//  DecodableArticle.swift
//  NimbleMedium
//
//  Created by Mark G on 06/09/2021.
//

import Foundation

struct DecodableArticle: Article, Decodable, Equatable {

    private enum CodingKeys: String, CodingKey {
        case slug, title, description, body, tagList, createdAt, updatedAt, favorited, favoritesCount
        case apiAuthor = "author"
    }

    let slug: String
    let title: String
    let description: String
    let body: String
    let tagList: [String]
    let createdAt: Date
    let updatedAt: Date
    let favorited: Bool
    let favoritesCount: Int

    private let apiAuthor: DecodableProfile
    var author: Profile {
        apiAuthor
    }
}
