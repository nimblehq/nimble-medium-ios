//
//  CreateArticleParameters+Dummy.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 18/10/2021.
//

@testable import NimbleMedium

extension CreateArticleParameters {

    static let dummy: CreateArticleParameters = {
        CreateArticleParameters(title: "", description: "", body: "", tagList: [])
    }()
}
