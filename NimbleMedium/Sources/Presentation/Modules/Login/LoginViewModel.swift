//
//  LoginViewModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 24/08/2021.
//

import RxSwift
import RxCocoa

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
    private let loginUseCase: LoginUseCaseProtocol

    var input: LoginViewModelInput { self }
    var output: LoginViewModelOutput { self }

    @PublishRelayProperty var didLogin: Signal<Void>
    @PublishRelayProperty var didSelectNoAccount: Signal<Void>
    @PublishRelayProperty var errorMessage: Signal<String>
    @BehaviorRelayProperty(false) var isLoading: Driver<Bool>

    init(factory: ModuleFactoryProtocol) {
        loginUseCase = factory.loginUseCase()
    }

    private func login(email: String, password: String) {
        loginUseCase
            .login(email: email, password: password)
            .subscribe(
                with: self,
                onCompleted: { owner in
                    owner.$isLoading.accept(false)
                    owner.$didLogin.accept(())
                }, onError: { owner, error  in
                    owner.$isLoading.accept(false)
                    owner.$errorMessage.accept(error.detail)
                })
            .disposed(by: disposeBag)
    }
}

extension LoginViewModel: LoginViewModelInput {

    func didTapLoginButton(email: String, password: String) {
        $isLoading.accept(true)
        login(email: email, password: password)
    }

    func didTapNoAccountButton() {
        $didSelectNoAccount.accept(())
    }
}

extension LoginViewModel: LoginViewModelOutput {}
