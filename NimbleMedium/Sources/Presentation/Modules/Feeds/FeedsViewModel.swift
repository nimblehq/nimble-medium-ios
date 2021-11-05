//
//  FeedsViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 12/08/2021.
//

import Resolver
import RxCocoa
import RxSwift
import SwiftUI

protocol FeedsViewModelInput {

    func bindData(
        sideMenuActionsViewModel: SideMenuActionsViewModelProtocol,
        userSessionViewModel: UserSessionViewModelProtocol
    )
    func toggleSideMenu()
}

protocol FeedsViewModelOutput {

    var yourFeedsViewModel: FeedsTabViewModelProtocol { get }
    var globalFeedsViewModel: FeedsTabViewModelProtocol { get }
    var didToggleSideMenu: Signal<Void> { get }
}

protocol FeedsViewModelProtocol: ObservableViewModel {

    var input: FeedsViewModelInput { get }
    var output: FeedsViewModelOutput { get }
}

final class FeedsViewModel: ObservableObject, FeedsViewModelProtocol {

    var input: FeedsViewModelInput { self }
    var output: FeedsViewModelOutput { self }

    private var currentOffset = 0

    private let limit = 10
    private let disposeBag = DisposeBag()
    private let getCurrentUserSessionTrigger = PublishRelay<Void>()

    @PublishRelayProperty var didToggleSideMenu: Signal<Void>

    let yourFeedsViewModel: FeedsTabViewModelProtocol
    let globalFeedsViewModel: FeedsTabViewModelProtocol

    init() {
        yourFeedsViewModel = Resolver.resolve(
            FeedsTabViewModelProtocol.self,
            args: FeedsTabView.TabType.yourFeeds
        )
        globalFeedsViewModel = Resolver.resolve(
            FeedsTabViewModelProtocol.self,
            args: FeedsTabView.TabType.globalFeeds
        )
    }
}

extension FeedsViewModel: FeedsViewModelInput {

    func bindData(
        sideMenuActionsViewModel: SideMenuActionsViewModelProtocol,
        userSessionViewModel: UserSessionViewModelProtocol
    ) {
        sideMenuActionsViewModel.output.didLogin.asObservable()
            .subscribe(
                with: self,
                onNext: { _, _ in userSessionViewModel.input.getUserSession() }
            )
            .disposed(by: disposeBag)

        sideMenuActionsViewModel.output.didLogout.asObservable()
            .subscribe(
                with: self,
                onNext: { _, _ in userSessionViewModel.input.getUserSession() }
            )
            .disposed(by: disposeBag)
    }

    func toggleSideMenu() {
        $didToggleSideMenu.accept(())
    }
}

extension FeedsViewModel: FeedsViewModelOutput {}
