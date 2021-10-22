//
//  UnfollowUserUseCase.swift
//  NimbleMedium
//
//  Created by Mark G on 12/10/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol UnfollowUserUseCaseProtocol: AnyObject {

    func execute(username: String) -> Completable
}

final class UnfollowUserUseCase: UnfollowUserUseCaseProtocol {

    private let userRepository: UserRepositoryProtocol

    init(
        userRepository: UserRepositoryProtocol
    ) {
        self.userRepository = userRepository
    }

    func execute(username: String) -> Completable {
        userRepository
            .unfollow(username: username)
    }
}
