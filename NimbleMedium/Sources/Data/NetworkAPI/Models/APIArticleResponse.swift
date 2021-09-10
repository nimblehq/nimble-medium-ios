//
//  APIArticleResponse.swift
//  NimbleMedium
//
//  Created by Mark G on 06/09/2021.
//

import Foundation

struct APIArticleResponse: Decodable, Equatable {

    let articlesCount: Int
    let articles: [DecodableArticle]
}
