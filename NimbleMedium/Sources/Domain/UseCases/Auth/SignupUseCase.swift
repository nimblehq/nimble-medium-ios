//
//  SignupUseCase.swift
//  NimbleMedium
//
//  Created by Minh Pham on 01/09/2021.
//

import RxSwift

protocol SignupUseCaseProtocol: AnyObject {

    func signup(username: String, email: String, password: String) -> Completable
}

final class SignupUseCase: SignupUseCaseProtocol {

    private let authRepository: AuthRepositoryProtocol
    private let userSessionRepository: UserSessionRepositoryProtocol

    init(
        authRepository: AuthRepositoryProtocol,
        userSessionRepository: UserSessionRepositoryProtocol
    ) {
        self.authRepository = authRepository
        self.userSessionRepository = userSessionRepository
    }

    func signup(username: String, email: String, password: String) -> Completable {
        authRepository
            .signup(username: username, email: email, password: password)
            .asObservable()
            .withUnretained(self)
            .flatMapLatest { owner, user -> Completable in
                owner.userSessionRepository.saveUser(user)
            }
            .asCompletable()
    }
}
