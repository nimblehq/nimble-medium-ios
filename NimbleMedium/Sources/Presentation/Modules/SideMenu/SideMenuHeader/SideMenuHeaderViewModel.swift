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

    var uiModel: Driver<SideMenuHeaderView.UIModel?> { get }
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

    @BehaviorRelayProperty(nil) var uiModel: Driver<SideMenuHeaderView.UIModel?>

    private let getCurrentUserSessionTrigger = PublishRelay<Void>()

    init() {
        getCurrentUserSessionTrigger
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                owner.getCurrentSessionUseCase
                    .getCurrentUserSession()
                    .map {
                        guard let user = $0 else { return nil }
                        return owner.generateUIModel(from: user)
                    }
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

private extension SideMenuHeaderViewModel {

    func generateUIModel(from user: User) -> SideMenuHeaderView.UIModel {
        var username = Localizable.defaultUsernameValue()
        if !user.username.isEmpty {
            username = user.username
        }
        return SideMenuHeaderView.UIModel(
            avatarURL: try? user.image?.asURL(),
            username: username
        )
    }
}

extension SideMenuHeaderViewModel: SideMenuHeaderViewModelInput {}

extension SideMenuHeaderViewModel: SideMenuHeaderViewModelOutput {}
