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

    func bindData(
        feedsViewModel: FeedsViewModelProtocol,
        sideMenuViewModel: SideMenuViewModelProtocol
    )
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
    private let unauthorizedNotificationTrigger = NotificationCenter.default.rx.notification(.unauthorized)

    var input: HomeViewModelInput { self }
    var output: HomeViewModelOutput { self }

    @Injected var logoutUseCase: LogoutUseCaseProtocol

    @PublishRelayProperty var didReceiveUnauthorized: Signal<Void>

    @Published var isSideMenuOpen: Bool = false

    init() {
        unauthorizedNotificationTrigger
            .withUnretained(self)
            .flatMapLatest { owner, _ in owner.unauthorizedNotificationTriggered() }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension HomeViewModel: HomeViewModelInput {

    func bindData(
        feedsViewModel: FeedsViewModelProtocol,
        sideMenuViewModel: SideMenuViewModelProtocol
    ) {
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

    func toggleSideMenu(_ value: Bool) {
        isSideMenuOpen = value
    }
}

extension HomeViewModel: HomeViewModelOutput {

    var isSideMenuOpenDidChange: Signal<Bool> {
        $isSideMenuOpen.asSignal()
    }
}

extension HomeViewModel {

    private func unauthorizedNotificationTriggered() -> Observable<Void> {
        logoutUseCase
            .execute()
            .do(
                onError: { error in print("Logout failed with error: \(error.detail)") },
                onCompleted: { print("Logout successfully") }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }
}
