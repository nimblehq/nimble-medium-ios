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

    init(
        authRepository: AuthRepositoryProtocol
    ) {
        self.authRepository = authRepository
    }

    func login(email: String, password: String) -> Completable {
        // TODO: Store user data in integrate task
        authRepository
            .login(email: email, password: password)
            .asCompletable()
    }
}
