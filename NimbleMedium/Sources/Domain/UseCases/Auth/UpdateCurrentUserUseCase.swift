//
//  UpdateCurrentUserUseCase.swift
//  NimbleMedium
//
//  Created by Minh Pham on 12/10/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol UpdateCurrentUserUseCaseProtocol: AnyObject {

    func execute(
        username: String,
        email: String,
        password: String,
        image: String?,
        bio: String?
    ) -> Completable
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

    func execute(
        username: String,
        email: String,
        password: String,
        image: String?,
        bio: String?
    ) -> Completable {
        authRepository
            .updateCurrentUser(
                username: username, email: email, password: password, image: image, bio: bio
            )
            .asObservable()
            .withUnretained(self)
            .flatMapLatest { owner, user -> Completable in
                owner.userSessionRepository.saveUser(user)
            }
            .asCompletable()
    }
}
