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
    
    var model: Driver<FeedRow.Model> { get }
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

    let model: Driver<FeedRow.Model>

    init(model: FeedRow.Model) {
        self.model = .just(model)
    }
}

extension FeedRowViewModel: FeedRowViewModelInput {}

extension FeedRowViewModel: FeedRowViewModelOutput {}
