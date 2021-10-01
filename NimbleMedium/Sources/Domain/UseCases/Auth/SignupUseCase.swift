//
//  SignupUseCase.swift
//  NimbleMedium
//
//  Created by Minh Pham on 01/09/2021.
//

import RxSwift

protocol SignupUseCaseProtocol: AnyObject {

    func execute(username: String, email: String, password: String) -> Completable
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

    func execute(username: String, email: String, password: String) -> Completable {
        authRepository
            .signup(username: username, email: email, password: password)
            .flatMapCompletable({ [weak self] user in
                guard let self = self else { return Completable.empty() }
                return self.userSessionRepository.saveUser(user)
            })
    }
}
