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
        var model: FeedRow.Model!

        describe("a FeedsViewModel") {

            beforeEach {
                Resolver.registerMockServices()
                if let article = APIArticleResponse.dummy.articles.first {
                    model = .init(article: article)
                }

                viewModel = FeedRowViewModel(model: model)
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
            }

            it("returns output model with correct value") {
                expect(viewModel.output.model)
                    .events(scheduler: scheduler, disposeBag: disposeBag) == [
                        .next(0, model),
                        .completed(0)
                    ]
            }
        }
    }
}
