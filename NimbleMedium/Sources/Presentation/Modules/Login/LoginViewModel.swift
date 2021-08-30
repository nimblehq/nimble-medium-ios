//
//  LoginViewModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 24/08/2021.
//

import Combine
import RxSwift
import RxCocoa

protocol LoginViewModelInput {

    func didTapLoginButton(email: String, password: String)
}

protocol LoginViewModelOutput {

    var didLogin: Signal<Void> { get }
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

    @PublishRelayProperty var errorMessage: Signal<String>
    @PublishRelayProperty var didLogin: Signal<Void>
    @BehaviorRelayProperty(false) var isLoading: Driver<Bool>

    init(factory: ModuleFactoryProtocol) {
        loginUseCase = factory.loginUseCase()
    }

    private func login(email: String, password: String) {
        loginUseCase
            .login(email: email, password: password)
            .subscribe(onCompleted: { [weak self] in
                self?.$isLoading.accept(false)
                self?.$didLogin.accept(())
            }, onError: { [weak self] in
                self?.$isLoading.accept(false)
                self?.$errorMessage.accept($0.detail)
            })
            .disposed(by: disposeBag)
    }
}

extension LoginViewModel: LoginViewModelInput {

    func didTapLoginButton(email: String, password: String) {
        $isLoading.accept(true)
        login(email: email, password: password)
    }
}

extension LoginViewModel: LoginViewModelOutput {}
