//
//  ArticleCommentRepositoryProtocol.swift
//  NimbleMedium
//
//  Created by Mark G on 15/09/2021.
//

import Foundation
import RxSwift

// sourcery: AutoMockable
protocol ArticleCommentRepositoryProtocol {

    func getComments(slug: String) -> Single<[ArticleComment]>
}
