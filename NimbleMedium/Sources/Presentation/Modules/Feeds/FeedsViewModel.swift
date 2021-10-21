//
//  FeedsViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 12/08/2021.
//

import RxSwift
import RxCocoa
import SwiftUI
import Resolver

protocol FeedsViewModelInput {

    func toggleSideMenu()
    func viewOnAppear()
}

protocol FeedsViewModelOutput {

    var yourFeedsViewModel: FeedsTabViewModelProtocol { get }
    var globalFeedsViewModel: FeedsTabViewModelProtocol { get }
    var didToggleSideMenu: Signal<Void> { get }
    var isAuthenticated: Driver<Bool> { get }
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
    @BehaviorRelayProperty(false) var isAuthenticated: Driver<Bool>

    let yourFeedsViewModel: FeedsTabViewModelProtocol
    let globalFeedsViewModel: FeedsTabViewModelProtocol

    @Injected private var getCurrentSessionUseCase: GetCurrentSessionUseCaseProtocol

    init() {
        yourFeedsViewModel = Resolver.resolve(
            FeedsTabViewModelProtocol.self,
            args: FeedsTabView.TabType.mine
        )
        globalFeedsViewModel = Resolver.resolve(
            FeedsTabViewModelProtocol.self,
            args: FeedsTabView.TabType.global
        )

        getCurrentUserSessionTrigger
            .withUnretained(self)
            .flatMapLatest { owner, _ in owner.getCurrentUserSessionTriggered(owner: owner) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension FeedsViewModel: FeedsViewModelInput {

    func toggleSideMenu() {
        $didToggleSideMenu.accept(())
    }

    func viewOnAppear() {
        getCurrentUserSessionTrigger.accept(())
    }
}

extension FeedsViewModel: FeedsViewModelOutput {}

// MARK: - Private

private extension FeedsViewModel {

    func getCurrentUserSessionTriggered(owner: FeedsViewModel) -> Observable<Void> {
        getCurrentSessionUseCase
            .execute()
            .map { $0 != nil }
            .do(
                onSuccess: { owner.$isAuthenticated.accept($0) },
                onError: { _ in owner.$isAuthenticated.accept(false) }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }
}
