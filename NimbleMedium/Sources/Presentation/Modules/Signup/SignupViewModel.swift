//
//  SignupViewModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 24/08/2021.
//

import RxSwift
import RxCocoa

protocol SignupViewModelInput {

    func didTapSignupButton(username: String, email: String, password: String)
    func didTapHaveAccountButton()
}

protocol SignupViewModelOutput {

    var didSignup: Signal<Void> { get }
    var didSelectHaveAccount: Signal<Void> { get }
    var errorMessage: Signal<String> { get }
    var isLoading: Driver<Bool> { get }
}

protocol SignupViewModelProtocol {

    var input: SignupViewModelInput { get }
    var output: SignupViewModelOutput { get }
}

final class SignupViewModel: SignupViewModelProtocol {

    private let disposeBag = DisposeBag()
    private let signupUseCase: SignupUseCaseProtocol

    var input: SignupViewModelInput { self }
    var output: SignupViewModelOutput { self }

    @PublishRelayProperty var didSignup: Signal<Void>
    @PublishRelayProperty var didSelectHaveAccount: Signal<Void>
    @PublishRelayProperty var errorMessage: Signal<String>
    @BehaviorRelayProperty(false) var isLoading: Driver<Bool>

    init(factory: ModuleFactoryProtocol) {
        signupUseCase = factory.signupUseCase()
    }

    private func signup(username: String, email: String, password: String) {
        signupUseCase
            .signup(username: username, email: email, password: password)
            .subscribe(
                with: self,
                onCompleted: { owner in
                    owner.$isLoading.accept(false)
                    owner.$didSignup.accept(())
                }, onError: { owner, error  in
                    owner.$isLoading.accept(false)
                    owner.$errorMessage.accept(error.detail)
                })
            .disposed(by: disposeBag)
    }
}

extension SignupViewModel: SignupViewModelInput {

    func didTapSignupButton(username: String, email: String, password: String) {
        $isLoading.accept(true)
        signup(username: username, email: email, password: password)
    }

    func didTapHaveAccountButton() {
        $didSelectHaveAccount.accept(())
    }
}

extension SignupViewModel: SignupViewModelOutput { }
