//
//  EditArticleView+UIModel.swift
//  NimbleMedium
//
//  Created by Mark G on 02/11/2021.
//

import Foundation

extension EditArticleView {

    struct UIModel: Equatable {

        let title: String
        let description: String
        let articleBody: String
        let tagsList: String
    }
}
