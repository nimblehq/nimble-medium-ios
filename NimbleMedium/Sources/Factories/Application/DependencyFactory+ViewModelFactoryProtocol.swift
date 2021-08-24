//
//  DependencyFactory+ViewModelFactoryProtocol.swift
//  NimbleMedium
//
//  Created by Minh Pham on 24/08/2021.
//

extension DependencyFactory: ViewModelFactoryProtocol {

    func loginViewModel() -> LoginViewModelProtocol {
        LoginViewModel()
    }
}
