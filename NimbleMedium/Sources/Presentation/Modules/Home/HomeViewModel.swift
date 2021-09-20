//
//  HomeViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 13/08/2021.
//

import Combine
import Resolver
import RxCocoa
import RxSwift

// sourcery: AutoMockable
protocol HomeViewModelInput {
    
    func toggleSideMenu(_ value: Bool)
}

// sourcery: AutoMockable
protocol HomeViewModelOutput {

    var isSideMenuOpen: Bool { get }
    var isSideMenuOpenDidChange: Signal<Bool> { get }
}

// sourcery: AutoMockable
protocol HomeViewModelProtocol: ObservableViewModel {

    var input: HomeViewModelInput { get }
    var output: HomeViewModelOutput { get }
}

final class HomeViewModel: ObservableObject, HomeViewModelProtocol {

    private let disposeBag = DisposeBag()

    var input: HomeViewModelInput { self }
    var output: HomeViewModelOutput { self }

    @Injected var feedsViewModel: FeedsViewModelProtocol
    @Injected var sideMenuViewModel: SideMenuViewModelProtocol

    @Published var isSideMenuOpen: Bool = false

    init() {
        feedsViewModel.output.didToggleSideMenu
            .emit(with: self) { viewModel, _ in
                viewModel.toggleSideMenu(true)
            }
            .disposed(by: disposeBag)

        sideMenuViewModel.output.didSelectMenuOption
            .withUnretained(self)
            .emit(with: self) { viewModel, _ in
                viewModel.toggleSideMenu(false)
            }
            .disposed(by: disposeBag)
    }
}

extension HomeViewModel: HomeViewModelInput {

    func toggleSideMenu(_ value: Bool) {
        isSideMenuOpen = value
    }
}

extension HomeViewModel: HomeViewModelOutput {

    var isSideMenuOpenDidChange: Signal<Bool> {
        $isSideMenuOpen.asSignal()
    }
}
