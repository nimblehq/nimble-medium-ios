//
//  SideMenuActionsViewModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 25/08/2021.
//

import Combine
import Resolver
import RxCocoa
import RxSwift

// sourcery: AutoMockable
protocol SideMenuActionsViewModelInput {

    func bindData(
        loginViewModel: LoginViewModelProtocol,
        signupViewModel: SignupViewModelProtocol,
        homeViewModel: HomeViewModelProtocol,
        userSessionViewModel: UserSessionViewModelProtocol
    )
    func selectLoginOption()
    func selectLogoutOption()
    func selectMyProfileOption()
    func selectSignupOption()
}

// sourcery: AutoMockable
protocol SideMenuActionsViewModelOutput {

    var didLogout: Signal<Void> { get }
    var didLogin: Signal<Void> { get }
    var didSelectLoginOption: Signal<Bool> { get }
    var didSelectMyProfileOption: Signal<Bool> { get }
    var didSelectSignupOption: Signal<Bool> { get }
}

// sourcery: AutoMockable
protocol SideMenuActionsViewModelProtocol: ObservableViewModel {

    var input: SideMenuActionsViewModelInput { get }
    var output: SideMenuActionsViewModelOutput { get }
}

final class SideMenuActionsViewModel: ObservableObject, SideMenuActionsViewModelProtocol {

    private let disposeBag = DisposeBag()

    var input: SideMenuActionsViewModelInput { self }
    var output: SideMenuActionsViewModelOutput { self }

    @PublishRelayProperty var didLogout: Signal<Void>
    @PublishRelayProperty var didLogin: Signal<Void>
    @PublishRelayProperty var didSelectLoginOption: Signal<Bool>
    @PublishRelayProperty var didSelectMyProfileOption: Signal<Bool>
    @PublishRelayProperty var didSelectSignupOption: Signal<Bool>

    @Injected var logoutUseCase: LogoutUseCaseProtocol

    private let logoutTrigger = PublishRelay<Void>()

    init() {
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
        homeViewModel: HomeViewModelProtocol,
        userSessionViewModel: UserSessionViewModelProtocol
    ) {
        loginViewModel.output.didSelectNoAccount.asObservable()
            .subscribe(
                with: self,
                onNext: { owner, _ in owner.selectSignupOption() }
            )
            .disposed(by: disposeBag)

        loginViewModel.output.didLogin.asObservable()
            .subscribe(
                with: self,
                onNext: { owner, _ in owner.$didLogin.accept(()) }
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
            .emit(with: self) { _, _ in userSessionViewModel.input.getUserSession() }
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

extension SideMenuActionsViewModel: SideMenuActionsViewModelOutput {}

extension SideMenuActionsViewModel {

    private func logoutTriggered(owner: SideMenuActionsViewModel) -> Observable<Void> {
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
