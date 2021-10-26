//
//  UpdateMyArticleParameters.swift
//  NimbleMedium
//
//  Created by Minh Pham on 26/10/2021.
//

import Foundation

struct UpdateMyArticleParameters: Encodable {

    let title: String?
    let description: String?
    let body: String?
    let tagList: [String]?

    init(
        title: String? = nil,
        description: String? = nil,
        body: String? = nil,
        tagList: [String]? = nil
    ) {
        self.title = title
        self.description = description
        self.body = body
        self.tagList = tagList
    }
}
