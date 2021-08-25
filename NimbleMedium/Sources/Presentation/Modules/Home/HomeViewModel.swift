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
    var feedsViewModel: Driver<FeedsViewModelProtocol> { get }
    var sideMenuViewModel: Driver<SideMenuViewModelProtocol> { get }
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

    let feedsViewModel: Driver<FeedsViewModelProtocol>
    let sideMenuViewModel: Driver<SideMenuViewModelProtocol>

    init(factory: ModuleFactoryProtocol) {
        let feedsViewModel = factory.feedsViewModel()
        self.feedsViewModel = Driver.just(feedsViewModel)
        let sideMenuViewModel = factory.sideMenuViewModel()
        self.sideMenuViewModel = Driver.just(sideMenuViewModel)

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
