//
//  LoginViewModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 24/08/2021.
//

import RxSwift
import Combine

protocol LoginViewModelInput {

    // TODO: To be implemented
}

protocol LoginViewModelOutput {

    // TODO: To be implemented
}

protocol LoginViewModelProtocol: ObservableViewModel {

    var input: LoginViewModelInput { get }
    var output: LoginViewModelOutput { get }
}

final class LoginViewModel: ObservableObject, LoginViewModelProtocol {

    var input: LoginViewModelInput { self }
    var output: LoginViewModelOutput { self }

}

extension LoginViewModel: LoginViewModelInput { }

extension LoginViewModel: LoginViewModelOutput { }
