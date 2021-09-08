//
//  ListArticlesUseCaseSpec.swift
//  NimbleMediumTests
//
//  Created by Mark G on 08/09/2021.
//

import Quick
import Nimble
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class ListArticlesUseCaseSpec: QuickSpec {

    override func spec() {
        var usecase: ListArticlesUseCase!
        var articleRepository: ArticleRepositoryProtocolMock!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("an ArticleRepository") {

            beforeEach {
                disposeBag = DisposeBag()
                articleRepository = ArticleRepositoryProtocolMock()
                usecase = ListArticlesUseCase(articleRepository: articleRepository)
                scheduler = TestScheduler(initialClock: 0)
            }

            describe("its listArticles() call") {

                let inputArticles = APIArticleResponse.dummy.articles
                var outputArticles: TestableObserver<[CodableArticle]>!

                beforeEach {
                    outputArticles = scheduler.createObserver([CodableArticle].self)
                    articleRepository.listArticlesTagAuthorFavoritedLimitOffsetReturnValue = .just(inputArticles)

                    usecase.listArticles(
                        tag: nil,
                        author: nil,
                        favorited: nil,
                        limit: nil,
                        offset: nil
                    )
                    .asObservable()
                    .map {
                        $0.compactMap { $0 as? CodableArticle }
                    }
                    .bind(to: outputArticles)
                    .disposed(by: disposeBag)
                }

                it("returns correct articles") {
                    expect(outputArticles.events.first?.value.element) == inputArticles
                }
            }
        }
    }
}
