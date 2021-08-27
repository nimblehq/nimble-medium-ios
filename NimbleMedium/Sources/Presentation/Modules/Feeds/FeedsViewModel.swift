//
//  FeedsViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 12/08/2021.
//

import RxSwift
import RxCocoa
import Combine

protocol FeedsViewModelInput {

    func toggleSideMenu()
}

protocol FeedsViewModelOutput {

    var didToggleSideMenu: Signal<Void> { get }
}

protocol FeedsViewModelProtocol: ObservableViewModel {

    var input: FeedsViewModelInput { get }
    var output: FeedsViewModelOutput { get }
}

final class FeedsViewModel: ObservableObject, FeedsViewModelProtocol {

    @PublishRelayProperty var didToggleSideMenu: Signal<Void>

    var input: FeedsViewModelInput { self }
    var output: FeedsViewModelOutput { self }

}

extension FeedsViewModel: FeedsViewModelInput {

    func toggleSideMenu() {
        $didToggleSideMenu.accept(())
    }
}

extension FeedsViewModel: FeedsViewModelOutput {}
