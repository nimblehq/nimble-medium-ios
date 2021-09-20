//
//  FeedRowViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 17/09/2021.
//

import Combine
import Resolver
import RxCocoa
import RxSwift

// sourcery: AutoMockable
protocol FeedRowViewModelInput {}

// sourcery: AutoMockable
protocol FeedRowViewModelOutput {
    
    var id: String { get }
    var articleTitle: Driver<String> { get }
    var articleDescription: Driver<String> { get }
    var authorImage: Driver<URL?> { get }
    var authorName: Driver<String> { get }
    var updatedAt: Driver<String> { get }
}

// sourcery: AutoMockable
protocol FeedRowViewModelProtocol: ObservableViewModel {

    var input: FeedRowViewModelInput { get }
    var output: FeedRowViewModelOutput { get }
}

final class FeedRowViewModel: ObservableObject, FeedRowViewModelProtocol {

    private let disposeBag = DisposeBag()

    var input: FeedRowViewModelInput { self }
    var output: FeedRowViewModelOutput { self }

    let id: String
    let articleTitle: Driver<String>
    let articleDescription: Driver<String>
    let authorImage: Driver<URL?>
    let authorName: Driver<String>
    let updatedAt: Driver<String>

    init(article: Article) {
        id = article.id
        articleTitle = Driver.just(article.title)
        articleDescription = Driver.just(article.description)
        authorImage = Driver.just(try? article.author.image?.asURL())
        authorName = Driver.just(article.author.username)
        updatedAt = Driver.just(article.updatedAt.format(with: .monthDayYear))
    }
}

extension FeedRowViewModel: FeedRowViewModelInput {}

extension FeedRowViewModel: FeedRowViewModelOutput {}
