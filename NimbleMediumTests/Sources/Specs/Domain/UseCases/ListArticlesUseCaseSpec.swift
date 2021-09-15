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

                context("when articleRepository.listArticles() returns success") {

                    let inputArticles = APIArticlesResponse.dummy.articles
                    var outputArticles: TestableObserver<[DecodableArticle]>!

                    beforeEach {
                        outputArticles = scheduler.createObserver([DecodableArticle].self)
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
                            $0.compactMap { $0 as? DecodableArticle }
                        }
                        .bind(to: outputArticles)
                        .disposed(by: disposeBag)
                    }

                    it("returns correct articles") {
                        expect(outputArticles.events.first?.value.element) == inputArticles
                    }
                }

                context("when articleRepository.listArticles() returns failure") {
                    
                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Optional<Error>.self)
                        articleRepository.listArticlesTagAuthorFavoritedLimitOffsetReturnValue = .error(TestError.mock)

                        usecase.listArticles(
                            tag: nil,
                            author: nil,
                            favorited: nil,
                            limit: nil,
                            offset: nil
                        )
                        .asObservable()
                        .materialize()
                        .map { $0.error }
                        .bind(to: outputError)
                        .disposed(by: disposeBag)
                    }

                    it("returns correct error") {
                        let error = outputError.events.first?.value.element as? TestError
                        expect(error) == TestError.mock
                    }
                }
            }
        }
    }
}
