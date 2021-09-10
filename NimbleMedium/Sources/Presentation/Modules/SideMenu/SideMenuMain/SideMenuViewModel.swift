//
//  SideMenuViewModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 25/08/2021.
//

import RxCocoa
import RxSwift
import Combine

protocol SideMenuViewModelInput {

    // TODO: To be implemented
}

protocol SideMenuViewModelOutput {

    var didSelectMenuOption: Signal<Void> { get }
    var sideMenuActionsViewModel: SideMenuActionsViewModelProtocol { get }
}

protocol SideMenuViewModelProtocol: ObservableViewModel {

    var input: SideMenuViewModelInput { get }
    var output: SideMenuViewModelOutput { get }
}

final class SideMenuViewModel: ObservableObject, SideMenuViewModelProtocol {

    var input: SideMenuViewModelInput { self }
    var output: SideMenuViewModelOutput { self }

    private let disposeBag = DisposeBag()

    let sideMenuActionsViewModel: SideMenuActionsViewModelProtocol

    @PublishRelayProperty var didSelectMenuOption: Signal<Void>

    init(factory: ModuleFactoryProtocol) {
        sideMenuActionsViewModel = factory.sideMenuActionsViewModel()
        sideMenuActionsViewModel.output.didSelectLoginOption.asObservable()
            .withUnretained(self)
            .bind { _ in
                self.$didSelectMenuOption.accept(())
            }
            .disposed(by: disposeBag)
        sideMenuActionsViewModel.output.didSelectSignupOption.asObservable()
            .withUnretained(self)
            .bind { _ in
                self.$didSelectMenuOption.accept(())
            }
            .disposed(by: disposeBag)
    }
}

extension SideMenuViewModel: SideMenuViewModelInput {}

extension SideMenuViewModel: SideMenuViewModelOutput {}
