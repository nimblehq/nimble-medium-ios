//
//  GetArticleUseCaseSpec.swift
//  NimbleMediumTests
//
//  Created by Mark G on 14/09/2021.
//

import Nimble
import Quick
import RxNimble
import RxSwift
import RxTest

@testable import NimbleMedium

final class GetArticleUseCaseSpec: QuickSpec {

    override func spec() {
        var usecase: GetArticleUseCase!
        var articleRepository: ArticleRepositoryProtocolMock!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("an ArticleRepository") {

            beforeEach {
                disposeBag = DisposeBag()
                articleRepository = ArticleRepositoryProtocolMock()
                usecase = GetArticleUseCase(articleRepository: articleRepository)
                scheduler = TestScheduler(initialClock: 0)
            }

            describe("its getArticle() call") {

                context("when articleRepository.getArticle() returns success") {

                    let inputArticle = APIArticleResponse.dummy.article
                    var outputArticle: TestableObserver<DecodableArticle>!

                    beforeEach {
                        outputArticle = scheduler.createObserver(DecodableArticle.self)
                        articleRepository.getArticleSlugReturnValue = .just(inputArticle)

                        usecase.execute(slug: "slug")
                            .asObservable()
                            .compactMap {
                                $0 as? DecodableArticle
                            }
                            .bind(to: outputArticle)
                            .disposed(by: disposeBag)
                    }

                    it("returns correct article") {
                        expect(outputArticle.events) == [
                            .next(0, inputArticle),
                            .completed(0)
                        ]
                    }
                }

                context("when articleRepository.getArticle() returns failure") {

                    var outputError: TestableObserver<Error?>!

                    beforeEach {
                        outputError = scheduler.createObserver(Error?.self)
                        articleRepository.getArticleSlugReturnValue = .error(TestError.mock)

                        usecase.execute(slug: "slug")
                            .asObservable()
                            .materialize()
                            .map { $0.error }
                            .bind(to: outputError)
                            .disposed(by: disposeBag)
                    }

                    it("returns correct error") {
                        let error = outputError.events.first?.value.element as? TestError

                        expect(outputError.events.count) == 2
                        expect(error) == TestError.mock
                        expect(outputError.events.last?.value.isCompleted) == true
                    }
                }
            }
        }
    }
}
