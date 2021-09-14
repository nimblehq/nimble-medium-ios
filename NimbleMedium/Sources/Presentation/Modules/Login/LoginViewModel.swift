//
//  LoginViewModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 24/08/2021.
//

import RxSwift
import RxCocoa
import Resolver

protocol LoginViewModelInput {

    func didTapLoginButton(email: String, password: String)
    func didTapNoAccountButton()
}

protocol LoginViewModelOutput {

    var didLogin: Signal<Void> { get }
    var didSelectNoAccount: Signal<Void> { get }
    var errorMessage: Signal<String> { get }
    var isLoading: Driver<Bool> { get }
}

protocol LoginViewModelProtocol: ObservableViewModel {

    var input: LoginViewModelInput { get }
    var output: LoginViewModelOutput { get }
}

final class LoginViewModel: ObservableObject, LoginViewModelProtocol {

    private let disposeBag = DisposeBag()
    private let loginTrigger = PublishRelay<(email: String, password: String)>()

    var input: LoginViewModelInput { self }
    var output: LoginViewModelOutput { self }

    @Injected var loginUseCase: LoginUseCaseProtocol

    @BehaviorRelayProperty(false) var isLoading: Driver<Bool>
    @PublishRelayProperty var didLogin: Signal<Void>
    @PublishRelayProperty var didSelectNoAccount: Signal<Void>
    @PublishRelayProperty var errorMessage: Signal<String>

    init() {
        loginTrigger.flatMapLatest { inputs in
            self.loginUseCase
                .login(email: inputs.email, password: inputs.password)
                .asObservable()
                .materialize()
        }
        .subscribe(
            with: self,
            onNext: { owner, event in
                owner.$isLoading.accept(false)
                if let error = event.error {
                    owner.$errorMessage.accept(error.detail)
                } else {
                    owner.$didLogin.accept(())
                }
            }
        )
        .disposed(by: disposeBag)
    }
}

extension LoginViewModel: LoginViewModelInput {

    func didTapLoginButton(email: String, password: String) {
        $isLoading.accept(true)
        loginTrigger.accept((email, password))
    }

    func didTapNoAccountButton() {
        $didSelectNoAccount.accept(())
    }
}

extension LoginViewModel: LoginViewModelOutput {}
