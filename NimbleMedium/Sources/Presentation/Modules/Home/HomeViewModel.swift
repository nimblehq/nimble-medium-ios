//
//  HomeViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 13/08/2021.
//

import RxCocoa
import RxSwift

protocol HomeViewModelInput {
    
    func toggleSideMenu(_ value: Bool)
}

protocol HomeViewModelOutput {

    var isSideMenuOpen: Driver<Bool> { get }
    var feedsViewModel: FeedsViewModelProtocol { get }
    var sideMenuViewModel: SideMenuViewModelProtocol { get }
}

protocol HomeViewModelProtocol {

    var input: HomeViewModelInput { get }
    var output: HomeViewModelOutput { get }
}

final class HomeViewModel: HomeViewModelProtocol, HomeViewModelOutput {

    private let disposeBag = DisposeBag()

    var input: HomeViewModelInput { self }
    var output: HomeViewModelOutput { self }

    @BehaviorRelayProperty(value: false) var isSideMenuOpen: Driver<Bool>

    let feedsViewModel: FeedsViewModelProtocol
    let sideMenuViewModel: SideMenuViewModelProtocol

    init(factory: ModuleFactoryProtocol) {
        feedsViewModel = factory.feedsViewModel()
        sideMenuViewModel = factory.sideMenuViewModel()

        feedsViewModel.output.didToggleSideMenu
            .withUnretained(self)
            .bind {
                $0.0.toggleSideMenu(true)
            }
            .disposed(by: disposeBag)

        sideMenuViewModel.output.didSelectMenuOption
            .withUnretained(self)
            .bind {
                $0.0.toggleSideMenu(false)
            }
            .disposed(by: disposeBag)
    }
}

extension HomeViewModel: HomeViewModelInput {

    func toggleSideMenu(_ value: Bool) {
        $isSideMenuOpen.accept(value)
    }
}
