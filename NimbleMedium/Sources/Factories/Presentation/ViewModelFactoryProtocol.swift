//
//  ViewModelFactoryProtocol.swift
//  NimbleMedium
//
//  Created by Minh Pham on 24/08/2021.
//

protocol ViewModelFactoryProtocol {

    func feedsViewModel() -> FeedsViewModelProtocol

    func homeViewModel() -> HomeViewModelProtocol
    
    func loginViewModel() -> LoginViewModelProtocol

    func sideMenuActionsViewModel() -> SideMenuActionsViewModelProtocol

    func sideMenuViewModel() -> SideMenuViewModelProtocol

    func signupViewModel() -> SignupViewModelProtocol
}
