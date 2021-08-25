//
//  SignupViewModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 24/08/2021.
//

import RxSwift

protocol SignupViewModelInput {

    // TODO: To be implemented
}

protocol SignupViewModelOutput {

    // TODO: To be implemented
}

protocol SignupViewModelProtocol {

    var input: SignupViewModelInput { get }
    var output: SignupViewModelOutput { get }
}

final class SignupViewModel: SignupViewModelProtocol {

    var input: SignupViewModelInput { self }
    var output: SignupViewModelOutput { self }

}

extension SignupViewModel: SignupViewModelInput { }

extension SignupViewModel: SignupViewModelOutput { }
