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

    var didLogin: Driver<HomeViewModelProtocol> { get }
    var errorMessage: Driver<String> { get }
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
    var didLogin: Driver<HomeViewModelProtocol>

    var isLoading: Driver<Bool>
    var errorMessage: Driver<String>

    init(factory: ModuleFactoryProtocol) {
        let indicator = RxActivityIndicator()
        let error = RxErrorTracker()
        let loginUseCase = factory.loginUseCase()
        didLogin = loginTrigger
            .flatMapLatest { inputs in
                loginUseCase
                    .login(email: inputs.email, password: inputs.password)
                    .trackIndicator(indicator)
                    .trackError(error)
                    .materialize()
            }
            .filter { $0.isCompleted }
            .map { _ in factory.homeViewModel() }
            .asDriverOrEmptyIfError()
        errorMessage = error.asDriver().map(\.detail)
        isLoading = indicator.asDriver()
    }
}

extension LoginViewModel: LoginViewModelInput {

    func didTapLoginButton(email: String, password: String) {
        loginTrigger.accept((email: email, password: password))
    }
}

extension LoginViewModel: LoginViewModelOutput { }
