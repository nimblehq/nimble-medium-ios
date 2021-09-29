//
//  GetUserProfileUseCase.swift
//  NimbleMedium
//
//  Created by Minh Pham on 27/09/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol GetUserProfileUseCaseProtocol: AnyObject {

    func execute(username: String) -> Single<Profile>
}

final class GetUserProfileUseCase: GetUserProfileUseCaseProtocol {

    private let userRepository: UserRepositoryProtocol

    init(
        userRepository: UserRepositoryProtocol
    ) {
        self.userRepository = userRepository
    }

    func execute(username: String) -> Single<Profile> {
        userRepository
            .getUserProfile(username: username)
    }
}
