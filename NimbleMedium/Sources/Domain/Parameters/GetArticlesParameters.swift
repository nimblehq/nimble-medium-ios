//
//  GetArticlesParameters.swift
//  NimbleMedium
//
//  Created by Mark G on 21/10/2021.
//

import Foundation

struct GetArticlesParameters: Encodable {

    let tag: String?
    let author: String?
    let favorited: String?
    let limit: Int?
    let offset: Int?

    init(
        tag: String? = nil,
        author: String? = nil,
        favorited: String? = nil,
        limit: Int? = nil,
        offset: Int? = nil
    ) {
        self.tag = tag
        self.author = author
        self.favorited = favorited
        self.limit = limit
        self.offset = offset
    }
}
