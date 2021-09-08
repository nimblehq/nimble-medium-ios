//
//  APIArticleResponse.swift
//  NimbleMedium
//
//  Created by Mark G on 06/09/2021.
//

import Foundation

struct APIArticleResponse: Codable, Equatable {

    let articlesCount: Int
    let articles: [CodableArticle]
}
