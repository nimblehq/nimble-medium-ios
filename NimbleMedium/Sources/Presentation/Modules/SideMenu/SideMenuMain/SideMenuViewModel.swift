//
//  SideMenuViewModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 25/08/2021.
//

import RxCocoa
import RxSwift

protocol SideMenuViewModelInput {

    // TODO: To be implemented
}

protocol SideMenuViewModelOutput {

    var didSelectMenuOption: Observable<Void> { get }
    var sideMenuActionsViewModel: Driver<SideMenuActionsViewModelProtocol> { get }
}

protocol SideMenuViewModelProtocol {

    var input: SideMenuViewModelInput { get }
    var output: SideMenuViewModelOutput { get }
}

final class SideMenuViewModel: SideMenuViewModelProtocol {

    var input: SideMenuViewModelInput { self }
    var output: SideMenuViewModelOutput { self }

    private let disposeBag = DisposeBag()

    let sideMenuActionsViewModel: Driver<SideMenuActionsViewModelProtocol>

    @PublishRelayProperty var didSelectMenuOption: Observable<Void>

    init(factory: ModuleFactoryProtocol) {
        let sideMenuActionsViewModel = factory.sideMenuActionsViewModel()
        self.sideMenuActionsViewModel = Driver.just(sideMenuActionsViewModel)
        sideMenuActionsViewModel.output.didSelectLoginOption.asObservable()
            .withUnretained(self)
            .bind { _ in
                self.$didSelectMenuOption.accept(())
            }
            .disposed(by: disposeBag)
    }
}

extension SideMenuViewModel: SideMenuViewModelInput {}

extension SideMenuViewModel: SideMenuViewModelOutput {}
