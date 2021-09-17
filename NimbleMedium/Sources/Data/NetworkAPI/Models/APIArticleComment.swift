//
//  APIArticleComment.swift
//  NimbleMedium
//
//  Created by Mark G on 15/09/2021.
//

import Foundation

struct APIArticleComment: ArticleComment, Decodable, Equatable {

    private enum CodingKeys: String, CodingKey {
        case id, createdAt, updatedAt, body
        case apiAuthor = "author"
    }

    let id: Int
    let createdAt: Date
    let updatedAt: Date
    let body: String
    
    private let apiAuthor: DecodableProfile
    var author: Profile { apiAuthor }
}
