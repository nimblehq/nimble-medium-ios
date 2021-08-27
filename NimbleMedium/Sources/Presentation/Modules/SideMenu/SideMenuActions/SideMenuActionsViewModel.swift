//
//  SideMenuActionsViewModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 25/08/2021.
//

import RxSwift
import RxCocoa
import Combine

protocol SideMenuActionsViewModelInput {

    func selectLoginOption()
}

protocol SideMenuActionsViewModelOutput {

    var didSelectLoginOption: Signal<Bool> { get }
    var loginViewModel: LoginViewModelProtocol { get }
}

protocol SideMenuActionsViewModelProtocol: ObservableViewModel {

    var input: SideMenuActionsViewModelInput { get }
    var output: SideMenuActionsViewModelOutput { get }
}

final class SideMenuActionsViewModel: ObservableObject, SideMenuActionsViewModelProtocol {

    var input: SideMenuActionsViewModelInput { self }
    var output: SideMenuActionsViewModelOutput { self }

    @PublishRelayProperty var didSelectLoginOption: Signal<Bool>

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
