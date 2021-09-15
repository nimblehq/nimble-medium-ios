//
//  SignupViewModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 24/08/2021.
//

import Resolver
import RxCocoa
import RxSwift

protocol SignupViewModelInput {

    func didTapSignupButton(username: String, email: String, password: String)
    func didTapHaveAccountButton()
}

protocol SignupViewModelOutput {

    var didSelectHaveAccount: Signal<Void> { get }
    var didSignup: Signal<Void> { get }
    var errorMessage: Signal<String> { get }
    var isLoading: Driver<Bool> { get }
}

protocol SignupViewModelProtocol: ObservableViewModel {

    var input: SignupViewModelInput { get }
    var output: SignupViewModelOutput { get }
}

final class SignupViewModel: ObservableObject, SignupViewModelProtocol {

    private let disposeBag = DisposeBag()
    private let signupTrigger = PublishRelay<(username: String, email: String, password: String)>()

    var input: SignupViewModelInput { self }
    var output: SignupViewModelOutput { self }

    @BehaviorRelayProperty(false) var isLoading: Driver<Bool>
    @PublishRelayProperty var didSelectHaveAccount: Signal<Void>
    @PublishRelayProperty var didSignup: Signal<Void>
    @PublishRelayProperty var errorMessage: Signal<String>

    @Injected var signupUseCase: SignupUseCaseProtocol

    init() {
        signupTrigger
            .withUnretained(self)
            .flatMapLatest { owner, inputs in
                owner.signupUseCase
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

    func didTapHaveAccountButton() {
        $didSelectHaveAccount.accept(())
    }

    func didTapSignupButton(username: String, email: String, password: String) {
        $isLoading.accept(true)
        signupTrigger.accept((username, email, password))
    }
}

extension SignupViewModel: SignupViewModelOutput { }
