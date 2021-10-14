//
//  UpdateCurrentUserUseCase.swift
//  NimbleMedium
//
//  Created by Minh Pham on 12/10/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol UpdateCurrentUserUseCaseProtocol: AnyObject {

    func execute(params: UpdateCurrentUserParameters) -> Completable
}

final class UpdateCurrentUserUseCase: UpdateCurrentUserUseCaseProtocol {

    private let authRepository: AuthRepositoryProtocol
    private let userSessionRepository: UserSessionRepositoryProtocol

    init(
        authRepository: AuthRepositoryProtocol,
        userSessionRepository: UserSessionRepositoryProtocol
    ) {
        self.authRepository = authRepository
        self.userSessionRepository = userSessionRepository
    }

    func execute(params: UpdateCurrentUserParameters) -> Completable {
        authRepository
            .updateCurrentUser(params: params)
            .asObservable()
            .withUnretained(self)
            .flatMapLatest { owner, user -> Completable in
                owner.userSessionRepository.saveUser(user)
            }
            .asCompletable()
    }
}
