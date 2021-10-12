//
//  FollowUserUseCase.swift
//  NimbleMedium
//
//  Created by Mark G on 12/10/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol FollowUserUseCaseProtocol: AnyObject {

    func execute(username: String) -> Completable
}

final class FollowUserUseCase: FollowUserUseCaseProtocol {

    private let userRepository: UserRepositoryProtocol

    init(
        userRepository: UserRepositoryProtocol
    ) {
        self.userRepository = userRepository
    }

    func execute(username: String) -> Completable {
        userRepository.follow(username: username)
    }
}
