//
//  SideMenuViewModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 25/08/2021.
//

import Combine
import Resolver
import RxCocoa
import RxSwift

protocol SideMenuViewModelInput {

    func bindData(sideMenuActionsViewModel: SideMenuActionsViewModelProtocol)
}

protocol SideMenuViewModelOutput {

    var didSelectMenuOption: Signal<Void> { get }
}

protocol SideMenuViewModelProtocol: ObservableViewModel {

    var input: SideMenuViewModelInput { get }
    var output: SideMenuViewModelOutput { get }
}

final class SideMenuViewModel: ObservableObject, SideMenuViewModelProtocol {

    var input: SideMenuViewModelInput { self }
    var output: SideMenuViewModelOutput { self }

    private let disposeBag = DisposeBag()

    @PublishRelayProperty var didSelectMenuOption: Signal<Void>
}

extension SideMenuViewModel: SideMenuViewModelInput {

    func bindData(sideMenuActionsViewModel: SideMenuActionsViewModelProtocol) {
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

extension SideMenuViewModel: SideMenuViewModelOutput {}
