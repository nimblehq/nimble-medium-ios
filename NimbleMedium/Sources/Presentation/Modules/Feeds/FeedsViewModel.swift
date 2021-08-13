//
//  FeedsViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 12/08/2021.
//

import Combine

protocol FeedsViewModelInput {

    func toggleSideMenu()
}

protocol FeedsViewModelOutput {}

protocol FeedsViewModelProtocol: ObservableObject {

    var input: FeedsViewModelInput { get }
    var output: FeedsViewModelOutput { get }
}

final class FeedsViewModel: FeedsViewModelProtocol {

    private let homeViewModelInput: HomeViewModelInput

    var input: FeedsViewModelInput { self }
    var output: FeedsViewModelOutput { self }

    init(homeViewModelInput: HomeViewModelInput) {
        self.homeViewModelInput = homeViewModelInput
    }

}

extension FeedsViewModel: FeedsViewModelInput {
    func toggleSideMenu() {
        homeViewModelInput.toggleSideMenu(true)
    }
}

extension FeedsViewModel: FeedsViewModelOutput {}
