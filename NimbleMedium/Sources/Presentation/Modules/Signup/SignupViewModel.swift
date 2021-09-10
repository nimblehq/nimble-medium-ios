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
    private let signupTrigger = PublishRelay<(username: String, email: String, password: String)>()

    var input: SignupViewModelInput { self }
    var output: SignupViewModelOutput { self }

    @PublishRelayProperty var didSignup: Signal<Void>
    @PublishRelayProperty var didSelectHaveAccount: Signal<Void>
    @PublishRelayProperty var errorMessage: Signal<String>
    @BehaviorRelayProperty(false) var isLoading: Driver<Bool>

    init(factory: ModuleFactoryProtocol) {
        let signupUseCase = factory.signupUseCase()

        signupTrigger.flatMapLatest { inputs in
            signupUseCase
                .signup(username: inputs.username, email: inputs.email, password: inputs.password)
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
                    owner.$didSignup.accept(())
                }
            }
        )
        .disposed(by: disposeBag)
    }
}

extension SignupViewModel: SignupViewModelInput {

    func didTapSignupButton(username: String, email: String, password: String) {
        $isLoading.accept(true)
        signupTrigger.accept((username, email, password))
    }

    func didTapHaveAccountButton() {
        $didSelectHaveAccount.accept(())
    }
}

extension SignupViewModel: SignupViewModelOutput { }
