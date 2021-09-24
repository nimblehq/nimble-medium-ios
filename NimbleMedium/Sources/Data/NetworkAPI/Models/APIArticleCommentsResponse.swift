//
//  APIArticleCommentsResponse.swift
//  NimbleMedium
//
//  Created by Mark G on 15/09/2021.
//

import Foundation

struct APIArticleCommentsResponse: Decodable, Equatable {

    let comments: [APIArticleComment]
}
