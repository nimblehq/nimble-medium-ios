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
    func selectSignupOption()
}

protocol SideMenuActionsViewModelOutput {

    var didSelectLoginOption: Signal<Bool> { get }
    var didSelectSignupOption: Signal<Bool> { get }
    var loginViewModel: LoginViewModelProtocol { get }
    var signupViewModel: SignupViewModelProtocol { get }
}

protocol SideMenuActionsViewModelProtocol: ObservableViewModel {

    var input: SideMenuActionsViewModelInput { get }
    var output: SideMenuActionsViewModelOutput { get }
}

final class SideMenuActionsViewModel: ObservableObject, SideMenuActionsViewModelProtocol {

    private let disposeBag = DisposeBag()

    var input: SideMenuActionsViewModelInput { self }
    var output: SideMenuActionsViewModelOutput { self }

    @PublishRelayProperty var didSelectLoginOption: Signal<Bool>
    @PublishRelayProperty var didSelectSignupOption: Signal<Bool>

    let loginViewModel: LoginViewModelProtocol
    let signupViewModel: SignupViewModelProtocol

    init(factory: ModuleFactoryProtocol) {
        loginViewModel = factory.loginViewModel()
        signupViewModel = factory.signupViewModel()

        loginViewModel.output.didSelectNoAccount.asObservable()
            .subscribe(with: self, onNext: { owner, _ in
                owner.$didSelectSignupOption.accept(true)
            })
            .disposed(by: disposeBag)
    }
}

extension SideMenuActionsViewModel: SideMenuActionsViewModelInput {

    func selectLoginOption() {
        $didSelectLoginOption.accept(true)
    }

    func selectSignupOption() {
        $didSelectSignupOption.accept(true)
    }
}

extension SideMenuActionsViewModel: SideMenuActionsViewModelOutput { }
