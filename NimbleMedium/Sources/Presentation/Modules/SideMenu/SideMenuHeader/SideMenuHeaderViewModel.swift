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

    func bindData(homeViewModel: HomeViewModelProtocol)
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

    @BehaviorRelayProperty(nil) var uiModel: Driver<SideMenuHeaderView.UIModel?>

    private let getCurrentUserSessionTrigger = PublishRelay<Void>()

    init() {
        getCurrentUserSessionTrigger
            .withUnretained(self)
            .flatMapLatest { owner, _ in owner.getCurrentUserSessionTriggered(owner: owner) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension SideMenuHeaderViewModel: SideMenuHeaderViewModelInput {

    func bindData(homeViewModel: HomeViewModelProtocol) {
        homeViewModel.output.isSideMenuOpenDidChange
            .emit(with: self) { owner, isOpen in
                guard isOpen else { return }
                owner.getCurrentUserSessionTrigger.accept(())
            }
            .disposed(by: disposeBag)
    }
}

extension SideMenuHeaderViewModel: SideMenuHeaderViewModelOutput {}

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

    func getCurrentUserSessionTriggered(owner: SideMenuHeaderViewModel) -> Observable<Void> {
        getCurrentSessionUseCase
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
            .mapToVoid()
            .catchAndReturn(())
    }
}
