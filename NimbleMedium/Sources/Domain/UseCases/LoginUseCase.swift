//
//  LoginUseCase.swift
//  NimbleMedium
//
//  Created by Minh Pham on 26/08/2021.
//

import RxSwift

protocol LoginUseCaseProtocol: AnyObject {

    func login(email: String, password: String) -> Completable
}

final class LoginUseCase: LoginUseCaseProtocol {

    private let authRepository: AuthRepositoryProtocol
    private let userSessionRepository: UserSessionRepositoryProtocol

    init(
        authRepository: AuthRepositoryProtocol,
        userSessionRepository: UserSessionRepositoryProtocol
    ) {
        self.authRepository = authRepository
        self.userSessionRepository = userSessionRepository
    }

    func login(email: String, password: String) -> Completable {
        authRepository
            .login(email: email, password: password)
            .asObservable()
            .withUnretained(self)
            .flatMapLatest { owner, user -> Completable in
                owner.userSessionRepository.saveUser(user)
            }
            .asCompletable()
    }
}
