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

// sourcery: AutoMockable
protocol SignupViewModelOutput {

    var didSelectHaveAccount: Signal<Void> { get }
    var didSignup: Signal<Void> { get }
    var errorMessage: Signal<String> { get }
    var isLoading: Driver<Bool> { get }
}

// sourcery: AutoMockable
protocol SignupViewModelProtocol: ObservableViewModel {

    var input: SignupViewModelInput { get }
    var output: SignupViewModelOutput { get }
}

final class SignupViewModel: ObservableObject, SignupViewModelProtocol {

    typealias SignupParams = (username: String, email: String, password: String)

    private let disposeBag = DisposeBag()
    private let signupTrigger = PublishRelay<SignupParams>()

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
            .flatMapLatest { owner, inputs in owner.signupTriggered(owner: owner, inputs: inputs) }
            .subscribe()
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

extension SignupViewModel: SignupViewModelOutput {}

extension SignupViewModel {

    private func signupTriggered(owner: SignupViewModel, inputs: SignupParams) -> Observable<Void> {
        signupUseCase
            .execute(username: inputs.username, email: inputs.email, password: inputs.password)
            .do(
                onError: { error in
                    owner.$isLoading.accept(false)
                    owner.$errorMessage.accept(error.detail)
                },
                onCompleted: {
                    owner.$isLoading.accept(false)
                    owner.$didSignup.accept(())
                }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }
}
