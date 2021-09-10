//
//  HomeViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 13/08/2021.
//

import RxCocoa
import RxSwift
import Combine

protocol HomeViewModelInput {
    
    func toggleSideMenu(_ value: Bool)
}

protocol HomeViewModelOutput {

    var isSideMenuOpen: Bool { get }
    var isSideMenuOpenDidChange: Signal<Bool> { get }
    var feedsViewModel: FeedsViewModelProtocol { get }
    var sideMenuViewModel: SideMenuViewModelProtocol { get }
}

protocol HomeViewModelProtocol: ObservableViewModel {

    var input: HomeViewModelInput { get }
    var output: HomeViewModelOutput { get }
}

final class HomeViewModel: ObservableObject, HomeViewModelProtocol {

    private let disposeBag = DisposeBag()

    var input: HomeViewModelInput { self }
    var output: HomeViewModelOutput { self }

    @Published var isSideMenuOpen: Bool = false

    let feedsViewModel: FeedsViewModelProtocol
    let sideMenuViewModel: SideMenuViewModelProtocol

    init(factory: ModuleFactoryProtocol) {
        feedsViewModel = factory.feedsViewModel()
        sideMenuViewModel = factory.sideMenuViewModel()

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
