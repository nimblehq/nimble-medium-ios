//
//  UserSessionViewModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 01/11/2021.
//

import Resolver
import RxCocoa
import RxSwift
import SwiftUI

// sourcery: AutoMockable
protocol UserSessionViewModelInput {

    func getUserSession()
}

// sourcery: AutoMockable
protocol UserSessionViewModelOutput {

    var isAuthenticated: Driver<Bool> { get }
}

// sourcery: AutoMockable
protocol UserSessionViewModelProtocol: ObservableViewModel {

    var input: UserSessionViewModelInput { get }
    var output: UserSessionViewModelOutput { get }
}

final class UserSessionViewModel: ObservableObject, UserSessionViewModelProtocol {

    var input: UserSessionViewModelInput { self }
    var output: UserSessionViewModelOutput { self }

    private let disposeBag = DisposeBag()
    private let getCurrentUserSessionTrigger = PublishRelay<Void>()

    @BehaviorRelayProperty(false) var isAuthenticated: Driver<Bool>

    @Injected private var getCurrentSessionUseCase: GetCurrentSessionUseCaseProtocol

    init() {
        getCurrentUserSessionTrigger
            .withUnretained(self)
            .flatMapLatest { owner, _ in owner.getCurrentUserSessionTriggered(owner: owner) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension UserSessionViewModel: UserSessionViewModelInput {

    func getUserSession() {
        getCurrentUserSessionTrigger.accept(())
    }
}

extension UserSessionViewModel: UserSessionViewModelOutput {}

// MARK: - Private

extension UserSessionViewModel {

    private func getCurrentUserSessionTriggered(owner: UserSessionViewModel) -> Observable<Void> {
        getCurrentSessionUseCase
            .execute()
            .map { $0 != nil }
            .do(
                onSuccess: { owner.$isAuthenticated.accept($0) },
                onError: { _ in owner.$isAuthenticated.accept(false) }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }
}
