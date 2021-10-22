//
//  GetCurrentUserUseCase.swift
//  NimbleMedium
//
//  Created by Minh Pham on 29/09/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol GetCurrentUserUseCaseProtocol: AnyObject {

    func execute() -> Single<User>
}

final class GetCurrentUserUseCase: GetCurrentUserUseCaseProtocol {

    private let authRepository: AuthRepositoryProtocol
    private let userSessionRepository: UserSessionRepositoryProtocol

    init(
        authRepository: AuthRepositoryProtocol,
        userSessionRepository: UserSessionRepositoryProtocol
    ) {
        self.authRepository = authRepository
        self.userSessionRepository = userSessionRepository
    }

    func execute() -> Single<User> {
        authRepository
            .getCurrentUser()
            .asObservable()
            .withUnretained(self)
            .flatMapLatest { owner, user -> Single<User> in
                owner.userSessionRepository.saveUser(user).andThen(.just(user))
            }
            .asSingle()
    }
}
