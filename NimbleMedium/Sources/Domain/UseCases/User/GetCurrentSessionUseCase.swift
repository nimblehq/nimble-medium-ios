//
//  GetCurrentSessionUseCase.swift
//  NimbleMedium
//
//  Created by Minh Pham on 20/09/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol GetCurrentSessionUseCaseProtocol: AnyObject {

    func execute() -> Single<User?>
}

final class GetCurrentSessionUseCase: GetCurrentSessionUseCaseProtocol {

    private let userSessionRepository: UserSessionRepositoryProtocol

    init(userSessionRepository: UserSessionRepositoryProtocol) {
        self.userSessionRepository = userSessionRepository
    }

    func execute() -> Single<User?> {
        userSessionRepository
            .getCurrentUser()
    }
}
