//
//  DependencyFactory+ViewModelFactoryProtocol.swift
//  NimbleMedium
//
//  Created by Minh Pham on 24/08/2021.
//

extension DependencyFactory: ViewModelFactoryProtocol {

    func feedsViewModel() -> FeedsViewModelProtocol {
        FeedsViewModel()
    }

    func homeViewModel() -> HomeViewModelProtocol {
        HomeViewModel(factory: self)
    }

    func loginViewModel() -> LoginViewModelProtocol {
        LoginViewModel()
    }

    func sideMenuActionsViewModel() -> SideMenuActionsViewModelProtocol {
        SideMenuActionsViewModel(factory: self)
    }

    func sideMenuViewModel() -> SideMenuViewModelProtocol {
        SideMenuViewModel(factory: self)
    }

    func signupViewModel() -> SignupViewModelProtocol {
        SignupViewModel()
    }
}
