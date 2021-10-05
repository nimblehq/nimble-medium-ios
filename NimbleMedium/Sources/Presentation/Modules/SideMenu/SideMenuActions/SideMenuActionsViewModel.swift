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

    func selectLoginOption()
    func selectMyProfileOption()
    func selectSignupOption()
}

protocol SideMenuActionsViewModelOutput {

    var didSelectLoginOption: Signal<Bool> { get }
    var didSelectMyProfileOption: Signal<Bool> { get }
    var didSelectSignupOption: Signal<Bool> { get }
}

protocol SideMenuActionsViewModelProtocol: ObservableViewModel {

    var input: SideMenuActionsViewModelInput { get }
    var output: SideMenuActionsViewModelOutput { get }
}

final class SideMenuActionsViewModel: ObservableObject, SideMenuActionsViewModelProtocol {

    private let disposeBag = DisposeBag()

    var input: SideMenuActionsViewModelInput { self }
    var output: SideMenuActionsViewModelOutput { self }

    @PublishRelayProperty var didSelectLoginOption: Signal<Bool>
    @PublishRelayProperty var didSelectMyProfileOption: Signal<Bool>
    @PublishRelayProperty var didSelectSignupOption: Signal<Bool>

    @Injected var loginViewModel: LoginViewModelProtocol
    @Injected var signupViewModel: SignupViewModelProtocol

    @Injected var getCurrentUserUseCase: GetCurrentUserUseCaseProtocol

    init() {
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
    }
}

extension SideMenuActionsViewModel: SideMenuActionsViewModelInput {

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
