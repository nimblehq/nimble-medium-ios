//
//  LoginViewModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 24/08/2021.
//

import Resolver
import RxCocoa
import RxSwift

// sourcery: AutoMockable
protocol LoginViewModelInput {

    func didTapLoginButton(email: String, password: String)
    func didTapNoAccountButton()
}

// sourcery: AutoMockable
protocol LoginViewModelOutput {

    var didLogin: Signal<Void> { get }
    var didSelectNoAccount: Signal<Void> { get }
    var errorMessage: Signal<String> { get }
    var isLoading: Driver<Bool> { get }
}

// sourcery: AutoMockable
protocol LoginViewModelProtocol: ObservableViewModel {

    var input: LoginViewModelInput { get }
    var output: LoginViewModelOutput { get }
}

final class LoginViewModel: ObservableObject, LoginViewModelProtocol {

    typealias LoginParams = (email: String, password: String)

    private let disposeBag = DisposeBag()
    private let loginTrigger = PublishRelay<LoginParams>()

    var input: LoginViewModelInput { self }
    var output: LoginViewModelOutput { self }

    @Injected var loginUseCase: LoginUseCaseProtocol

    @BehaviorRelayProperty(false) var isLoading: Driver<Bool>
    @PublishRelayProperty var didLogin: Signal<Void>
    @PublishRelayProperty var didSelectNoAccount: Signal<Void>
    @PublishRelayProperty var errorMessage: Signal<String>

    init() {
        loginTrigger
            .withUnretained(self)
            .flatMapLatest { owner, inputs in owner.loginTriggered(owner: owner, inputs: inputs) }
            .subscribe()
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

extension LoginViewModel {

    private func loginTriggered(owner: LoginViewModel, inputs: LoginParams) -> Observable<Void> {
        loginUseCase.execute(email: inputs.email, password: inputs.password)
            .do(
                onError: { error in
                    owner.$isLoading.accept(false)
                    owner.$errorMessage.accept(error.detail)
                },
                onCompleted: {
                    owner.$isLoading.accept(false)
                    owner.$didLogin.accept(())
                }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }
}
