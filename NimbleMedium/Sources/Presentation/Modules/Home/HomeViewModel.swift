//
//  HomeViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 13/08/2021.
//

import Combine

protocol HomeViewModelInput {
    
    func toggleSideMenu(_ value: Bool)
}

protocol HomeViewModelOutput {

    var isSideMenuOpen: Bool { get }
}

protocol HomeViewModelProtocol: ObservableObject {

    var input: HomeViewModelInput { get }
    var output: HomeViewModelOutput { get }
}

final class HomeViewModel: HomeViewModelProtocol {

    var input: HomeViewModelInput { self }
    var output: HomeViewModelOutput { self }

    @Published var isSideMenuOpen: Bool = false
}

extension HomeViewModel: HomeViewModelInput {

    func toggleSideMenu(_ value: Bool) {
        isSideMenuOpen = value
    }
}

extension HomeViewModel: HomeViewModelOutput {}
