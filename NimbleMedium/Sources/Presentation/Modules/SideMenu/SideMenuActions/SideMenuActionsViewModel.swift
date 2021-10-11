//
//  SideMenuActionsViewModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 25/08/2021.
//

import RxSwift
import RxCocoa
import Combine
import Resolver

protocol SideMenuActionsViewModelInput {

    func bindData(
        loginViewModel: LoginViewModelProtocol,
        signupViewModel: SignupViewModelProtocol,
        homeViewModel: HomeViewModelProtocol
    )
    func selectLoginOption()
    func selectLogoutOption()
    func selectMyProfileOption()
    func selectSignupOption()
}

protocol SideMenuActionsViewModelOutput {

    var didLogout: Signal<Void> { get }
    var didSelectLoginOption: Signal<Bool> { get }
    var didSelectMyProfileOption: Signal<Bool> { get }
    var didSelectSignupOption: Signal<Bool> { get }
    var isAuthenticated: Driver<Bool> { get }
}

protocol SideMenuActionsViewModelProtocol: ObservableViewModel {

    var input: SideMenuActionsViewModelInput { get }
    var output: SideMenuActionsViewModelOutput { get }
}

final class SideMenuActionsViewModel: ObservableObject, SideMenuActionsViewModelProtocol {

    private let disposeBag = DisposeBag()

    var input: SideMenuActionsViewModelInput { self }
    var output: SideMenuActionsViewModelOutput { self }

    @PublishRelayProperty var didLogout: Signal<Void>
    @PublishRelayProperty var didSelectLoginOption: Signal<Bool>
    @PublishRelayProperty var didSelectMyProfileOption: Signal<Bool>
    @PublishRelayProperty var didSelectSignupOption: Signal<Bool>

    @BehaviorRelayProperty(false) var isAuthenticated: Driver<Bool>

    @Injected var getCurrentSessionUseCase: GetCurrentSessionUseCaseProtocol
    @Injected var logoutUseCase: LogoutUseCaseProtocol

    private let getCurrentUserSessionTrigger = PublishRelay<Void>()
    private let logoutTrigger = PublishRelay<Void>()

    init() {
        getCurrentUserSessionTrigger
            .withUnretained(self)
            .flatMapLatest { owner, _ in owner.getCurrentUserSessionTriggered(owner: owner) }
            .subscribe()
            .disposed(by: disposeBag)

        logoutTrigger
            .withUnretained(self)
            .flatMapLatest { owner, _ in owner.logoutTriggered(owner: owner) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension SideMenuActionsViewModel: SideMenuActionsViewModelInput {

    func bindData(
        loginViewModel: LoginViewModelProtocol,
        signupViewModel: SignupViewModelProtocol,
        homeViewModel: HomeViewModelProtocol
    ) {
        loginViewModel.output.didSelectNoAccount.asObservable()
            .subscribe(
                with: self,
                onNext: { owner, _ in owner.selectSignupOption() }
            )
            .disposed(by: disposeBag)

        signupViewModel.output.didSelectHaveAccount.asObservable()
            .subscribe(
                with: self,
                onNext: { owner, _ in owner.selectLoginOption() }
            )
            .disposed(by: disposeBag)

        homeViewModel.output.isSideMenuOpenDidChange
            .filter { $0 }
            .emit(with: self) { owner, _ in owner.getCurrentUserSessionTrigger.accept(()) }
            .disposed(by: disposeBag)
    }

    func selectLogoutOption() {
        logoutTrigger.accept(())
    }

    func selectLoginOption() {
        $didSelectLoginOption.accept(true)
    }

    func selectMyProfileOption() {
        $didSelectMyProfileOption.accept(true)
    }

    func selectSignupOption() {
        $didSelectSignupOption.accept(true)
    }
}

extension SideMenuActionsViewModel: SideMenuActionsViewModelOutput { }

private extension SideMenuActionsViewModel {

    func getCurrentUserSessionTriggered(owner: SideMenuActionsViewModel) -> Observable<Void> {
        getCurrentSessionUseCase
            .getCurrentUserSession()
            .map { $0 != nil }
            .do(
                onSuccess: { owner.$isAuthenticated.accept($0) },
                onError: { _ in owner.$isAuthenticated.accept(false) }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }

    func logoutTriggered(owner: SideMenuActionsViewModel) -> Observable<Void> {
        logoutUseCase
            .execute()
            .do(
                onError: { error in print("Logout failed with error: \(error.detail)") },
                onCompleted: { owner.$didLogout.accept(()) }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }
}
