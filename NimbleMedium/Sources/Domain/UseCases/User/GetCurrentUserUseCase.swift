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

    init(
        authRepository: AuthRepositoryProtocol
    ) {
        self.authRepository = authRepository
    }

    func execute() -> Single<User> {
        authRepository.getCurrentUser()
    }
}
