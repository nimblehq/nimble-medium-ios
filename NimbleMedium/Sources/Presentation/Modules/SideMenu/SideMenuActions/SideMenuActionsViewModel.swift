//
//  SideMenuActionsViewModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 25/08/2021.
//

import RxSwift
import RxCocoa

protocol SideMenuActionsViewModelInput {

    func selectLoginOption()
}

protocol SideMenuActionsViewModelOutput {

    var didSelectLoginOption: Driver<Bool> { get }
    var loginViewModel: LoginViewModelProtocol { get }
}

protocol SideMenuActionsViewModelProtocol {

    var input: SideMenuActionsViewModelInput { get }
    var output: SideMenuActionsViewModelOutput { get }
}

final class SideMenuActionsViewModel: SideMenuActionsViewModelProtocol {

    var input: SideMenuActionsViewModelInput { self }
    var output: SideMenuActionsViewModelOutput { self }

    @BehaviorRelayProperty(value: false) var didSelectLoginOption: Driver<Bool>

    let loginViewModel: LoginViewModelProtocol

    init(factory: ModuleFactoryProtocol) {
        loginViewModel = factory.loginViewModel()
    }
}

extension SideMenuActionsViewModel: SideMenuActionsViewModelInput {

    func selectLoginOption() {
        $didSelectLoginOption.accept(true)
    }
}

extension SideMenuActionsViewModel: SideMenuActionsViewModelOutput { }
