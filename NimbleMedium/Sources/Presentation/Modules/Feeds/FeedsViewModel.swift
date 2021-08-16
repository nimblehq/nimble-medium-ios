//
//  FeedsViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 12/08/2021.
//

import RxSwift

protocol FeedsViewModelInput {

    func toggleSideMenu()
}

protocol FeedsViewModelOutput {

    var didToggleSideMenu: Observable<Void> { get }
}

protocol FeedsViewModelProtocol {

    var input: FeedsViewModelInput { get }
    var output: FeedsViewModelOutput { get }
}

final class FeedsViewModel: FeedsViewModelProtocol {

    @PublishRelayProperty var didToggleSideMenu: Observable<Void>

    var input: FeedsViewModelInput { self }
    var output: FeedsViewModelOutput { self }

}

extension FeedsViewModel: FeedsViewModelInput {

    func toggleSideMenu() {
        $didToggleSideMenu.accept(())
    }
}

extension FeedsViewModel: FeedsViewModelOutput {}
