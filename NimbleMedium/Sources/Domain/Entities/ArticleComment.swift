//
//  ArticleComment.swift
//  NimbleMedium
//
//  Created by Mark G on 15/09/2021.
//

import Foundation

protocol ArticleComment {

    var id: Int { get }
    var createdAt: Date { get }
    var updatedAt: Date { get }
    var body: String { get }
    var author: Profile { get }
}
