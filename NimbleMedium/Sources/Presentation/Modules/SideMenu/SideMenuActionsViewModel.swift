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
    var loginViewModel: Driver<LoginViewModelProtocol> { get }
}

protocol SideMenuActionsViewModelProtocol {

    var input: SideMenuActionsViewModelInput { get }
    var output: SideMenuActionsViewModelOutput { get }
}

final class SideMenuActionsViewModel: SideMenuActionsViewModelProtocol {

    var input: SideMenuActionsViewModelInput { self }
    var output: SideMenuActionsViewModelOutput { self }

    @BehaviorRelayProperty(value: false) var didSelectLoginOption: Driver<Bool>

    let loginViewModel: Driver<LoginViewModelProtocol>

    init(factory: ModuleFactoryProtocol) {
        self.loginViewModel = Driver.just(factory.loginViewModel())
    }
}

extension SideMenuActionsViewModel: SideMenuActionsViewModelInput {

    func selectLoginOption() {
        $didSelectLoginOption.accept(true)
    }
}

extension SideMenuActionsViewModel: SideMenuActionsViewModelOutput { }
