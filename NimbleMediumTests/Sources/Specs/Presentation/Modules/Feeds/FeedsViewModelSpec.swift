//
//  FeedsViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Mark G on 13/09/2021.
//

import Quick
import Nimble
import RxNimble
import RxSwift
import RxTest
import Resolver

@testable import NimbleMedium

final class FeedsViewModelSpec: QuickSpec {

    @LazyInjected var listArticlesUseCase: ListArticlesUseCaseProtocolMock

    override func spec() {
        var viewModel: FeedsViewModel!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a FeedsViewModel") {

            beforeEach {
                Resolver.registerMockServices()

                viewModel = FeedsViewModel()
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
            }

            describe("its toggleSideMenu() call") {

                var didToggleSideMenu: TestableObserver<Void>!

                beforeEach {
                    didToggleSideMenu = scheduler.createObserver(Void.self)
                    viewModel.output.didToggleSideMenu
                        .asObservable()
                        .bind(to: didToggleSideMenu)
                        .disposed(by: disposeBag)

                    viewModel.toggleSideMenu()
                }

                it("returns output didToggleSideMenu with signal") {
                    expect(didToggleSideMenu.events.count) == 1
                }
            }

            describe("its refresh() call") {

                context("when ListArticlesUseCase return success") {
                    var didFinishRefresh: TestableObserver<Void>!
                    let inputArticles = APIArticleResponse.dummy.articles
                    var outputArticles: TestableObserver<[DecodableArticle]>!

                    beforeEach {
                        didFinishRefresh = scheduler.createObserver(Void.self)
                        outputArticles = scheduler.createObserver([DecodableArticle].self)

                        // swiftlint:disable line_length
                        self.listArticlesUseCase.listArticlesTagAuthorFavoritedLimitOffsetReturnValue = .just(inputArticles)

                        viewModel.output.articles
                            .asObservable()
                            .map { $0.compactMap { $0 as? DecodableArticle } }
                            .bind(to: outputArticles)
                            .disposed(by: disposeBag)

                        viewModel.output.didFinishRefresh
                            .asObservable()
                            .bind(to: didFinishRefresh)
                            .disposed(by: disposeBag)

                        viewModel.refresh()
                    }

                    it("returns output didFinishRefresh with signal") {
                        expect(didFinishRefresh.events.count) == 1
                    }

                    it("returns output articles with correct value") {
                        expect(outputArticles.events.last?.value.element) == inputArticles
                    }

                    it("resets current offset") {
                        expect(viewModel.currentOffset) == 0
                    }
                }

                context("when ListArticlesUseCase return failure") {
                    var didFinishRefresh: TestableObserver<Void>!
                    var outputError: TestableObserver<Error>!

                    beforeEach {
                        didFinishRefresh = scheduler.createObserver(Void.self)
                        outputError = scheduler.createObserver(Error.self)

                        // swiftlint:disable line_length
                        self.listArticlesUseCase.listArticlesTagAuthorFavoritedLimitOffsetReturnValue = .error(TestError.mock)

                        viewModel.output.didFailToLoadArticle
                            .asObservable()
                            .bind(to: outputError)
                            .disposed(by: disposeBag)

                        viewModel.output.didFinishRefresh
                            .asObservable()
                            .bind(to: didFinishRefresh)
                            .disposed(by: disposeBag)

                        viewModel.refresh()
                    }

                    it("returns output didFinishRefresh with signal") {
                        expect(didFinishRefresh.events.count) == 1
                    }

                    it("returns output didFailToLoadArticle with correct error") {
                        let error = outputError.events.first?.value.element as? TestError
                        expect(error) == TestError.mock
                    }
                }
            }

            describe("its loadMore() call") {

                context("when ListArticlesUseCase return success") {

                    context("when ListArticlesUseCase return empty") {
                        var didFinishLoadMore: TestableObserver<Bool>!
                        let inputArticles: [DecodableArticle] = []
                        var outputArticles: TestableObserver<[DecodableArticle]>!

                        beforeEach {
                            didFinishLoadMore = scheduler.createObserver(Bool.self)
                            outputArticles = scheduler.createObserver([DecodableArticle].self)

                            self.listArticlesUseCase.listArticlesTagAuthorFavoritedLimitOffsetReturnValue = .just(inputArticles)

                            viewModel.output.articles
                                .asObservable()
                                .map { $0.compactMap { $0 as? DecodableArticle } }
                                .bind(to: outputArticles)
                                .disposed(by: disposeBag)

                            viewModel.output.didFinishLoadMore
                                .asObservable()
                                .bind(to: didFinishLoadMore)
                                .disposed(by: disposeBag)

                            viewModel.loadMore()
                        }

                        it("returns output didFinishLoadMore with correct value") {
                            expect(didFinishLoadMore.events.first?.value.element) == false
                        }

                        it("returns output articles with correct value") {
                            expect(outputArticles.events.last?.value.element) == inputArticles
                        }

                        it("updates current offset with correct value") {
                            expect(viewModel.currentOffset) == 0
                        }
                    }

                    context("when ListArticlesUseCase return non-empty") {
                        var didFinishLoadMore: TestableObserver<Bool>!
                        let inputArticles = APIArticleResponse.dummy.articles
                        var outputArticles: TestableObserver<[DecodableArticle]>!

                        beforeEach {
                            didFinishLoadMore = scheduler.createObserver(Bool.self)
                            outputArticles = scheduler.createObserver([DecodableArticle].self)

                            self.listArticlesUseCase.listArticlesTagAuthorFavoritedLimitOffsetReturnValue = .just(inputArticles)

                            viewModel.output.articles
                                .asObservable()
                                .map { $0.compactMap { $0 as? DecodableArticle } }
                                .bind(to: outputArticles)
                                .disposed(by: disposeBag)

                            viewModel.output.didFinishLoadMore
                                .asObservable()
                                .bind(to: didFinishLoadMore)
                                .disposed(by: disposeBag)

                            viewModel.loadMore()
                        }

                        it("returns output didFinishLoadMore with correct value") {
                            expect(didFinishLoadMore.events.first?.value.element) == true
                        }

                        it("returns output articles with correct value") {
                            expect(outputArticles.events.last?.value.element) == inputArticles
                        }

                        it("updates current offset with correct value") {
                            expect(viewModel.currentOffset) == viewModel.limit
                        }
                    }
                }

                context("when ListArticlesUseCase return failure") {
                    var didFinishLoadMore: TestableObserver<Bool>!
                    var outputError: TestableObserver<Error>!

                    beforeEach {
                        didFinishLoadMore = scheduler.createObserver(Bool.self)
                        outputError = scheduler.createObserver(Error.self)

                        // swiftlint:disable line_length
                        self.listArticlesUseCase.listArticlesTagAuthorFavoritedLimitOffsetReturnValue = .error(TestError.mock)

                        viewModel.output.didFailToLoadArticle
                            .asObservable()
                            .bind(to: outputError)
                            .disposed(by: disposeBag)

                        viewModel.output.didFinishLoadMore
                            .asObservable()
                            .bind(to: didFinishLoadMore)
                            .disposed(by: disposeBag)

                        viewModel.loadMore()
                    }

                    it("returns output didFinishLoadMore with correct value") {
                        expect(didFinishLoadMore.events.first?.value.element) == true
                    }

                    it("returns output didFailToLoadArticle with correct error") {
                        let error = outputError.events.first?.value.element as? TestError
                        expect(error) == TestError.mock
                    }
                }
            }
        }
    }
}
