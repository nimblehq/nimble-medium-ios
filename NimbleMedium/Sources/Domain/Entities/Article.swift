//
//  Article.swift
//  NimbleMedium
//
//  Created by Mark G on 01/09/2021.
//

import Foundation

protocol Article {

    var id: String { get }
    var slug: String { get }
    var title: String { get }
    var description: String { get }
    var body: String { get }
    var tagList: [String] { get }
    var createdAt: Date { get }
    var updatedAt: Date { get }
    var favorited: Bool { get }
    var favoritesCount: Int { get }
    var author: Profile { get }
}

extension Article {

    var id: String { slug }
}
