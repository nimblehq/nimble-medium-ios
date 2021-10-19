//
//  CreateArticleParameters.swift
//  NimbleMedium
//
//  Created by Minh Pham on 18/10/2021.
//

import Foundation

struct CreateArticleParameters: Encodable {

    let title: String
    let description: String
    let body: String
    let tagList: [String]
}
