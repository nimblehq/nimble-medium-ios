//
//  FeedRowViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Mark G on 20/09/2021.
//

import Foundation

import Quick
import Nimble
import RxNimble
import RxSwift
import RxTest
import Resolver

@testable import NimbleMedium

final class FeedRowViewModelSpec: QuickSpec {

    @LazyInjected var listArticlesUseCase: ListArticlesUseCaseProtocolMock

    override func spec() {
        var viewModel: FeedRowViewModelProtocol!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var article: Article!

        describe("a FeedsViewModel") {

            beforeEach {
                Resolver.registerMockServices()
                article = APIArticleResponse.dummy.articles.first
                viewModel = FeedRowViewModel(article: article)
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
            }

            it("returns output articleTitle with correct value") {
                expect(viewModel.output.articleTitle)
                    .events(scheduler: scheduler, disposeBag: disposeBag) == [
                        .next(0, article.title),
                        .completed(0)
                    ]
            }

            it("returns output articleDescription with correct value") {
                expect(viewModel.output.articleDescription)
                    .events(scheduler: scheduler, disposeBag: disposeBag) == [
                        .next(0, article.description),
                        .completed(0)
                    ]
            }

            it("returns output authorName with correct value") {
                expect(viewModel.output.authorName)
                    .events(scheduler: scheduler, disposeBag: disposeBag) == [
                        .next(0, article.author.username),
                        .completed(0)
                    ]
            }

            it("returns output authorImage with correct value") {
                expect(viewModel.output.authorImage)
                    .events(scheduler: scheduler, disposeBag: disposeBag) == [
                        .next(0, try? article.author.image?.asURL()),
                        .completed(0)
                    ]
            }

            it("returns output updatedAt with correct value") {
                expect(viewModel.output.updatedAt)
                    .events(scheduler: scheduler, disposeBag: disposeBag) == [
                        .next(0, article.updatedAt.format(with: .monthDayYear)),
                        .completed(0)
                    ]
            }
        }
    }
}
