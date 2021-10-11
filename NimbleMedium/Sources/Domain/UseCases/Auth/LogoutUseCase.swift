//
//  LogoutUseCase.swift
//  NimbleMedium
//
//  Created by Minh Pham on 11/10/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol LogoutUseCaseProtocol: AnyObject {

    func execute() -> Completable
}

final class LogoutUseCase: LogoutUseCaseProtocol {

    private let userSessionRepository: UserSessionRepositoryProtocol

    init(
        userSessionRepository: UserSessionRepositoryProtocol
    ) {
        self.userSessionRepository = userSessionRepository
    }

    func execute() -> Completable {
        userSessionRepository
            .removeCurrentUser()
    }
}
