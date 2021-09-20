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

protocol SideMenuHeaderViewModelInput {

    // TODO: To be implemented
}

protocol SideMenuHeaderViewModelOutput {

    var uiModel: Driver<SideMenuHeaderUiModel?> { get }
}

protocol SideMenuHeaderViewModelProtocol: ObservableViewModel {

    var input: SideMenuHeaderViewModelInput { get }
    var output: SideMenuHeaderViewModelOutput { get }
}

final class SideMenuHeaderViewModel: ObservableObject, SideMenuHeaderViewModelProtocol {

    var input: SideMenuHeaderViewModelInput { self }
    var output: SideMenuHeaderViewModelOutput { self }

    private let disposeBag = DisposeBag()

    @Injected var getCurrentSessionUseCase: GetCurrentSessionUseCaseProtocol
    @Injected var homeViewModel: HomeViewModelProtocol

    @BehaviorRelayProperty(nil) var uiModel: Driver<SideMenuHeaderUiModel?>

    private let getCurrentUserSessionTrigger = PublishRelay<Void>()

    init() {
        getCurrentUserSessionTrigger
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                owner.getCurrentSessionUseCase
                    .getCurrentUserSession()
                    .map { $0?.toSideMenuHeaderUiModel }
                    .do(
                        onSuccess: { owner.$uiModel.accept($0) },
                        onError: { _ in owner.$uiModel.accept(nil) }
                    )
                    .asObservable()
                    .catchAndReturn(nil)
            }
            .subscribe()
            .disposed(by: disposeBag)

        homeViewModel.output.isSideMenuOpenDidChange
            .emit(with: self) { viewModel, isOpen in
                guard isOpen else { return }
                viewModel.getCurrentUserSessionTrigger.accept(())
            }
            .disposed(by: disposeBag)
    }
}

extension SideMenuHeaderViewModel: SideMenuHeaderViewModelInput {}

extension SideMenuHeaderViewModel: SideMenuHeaderViewModelOutput {}
