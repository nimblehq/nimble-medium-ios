//
//  UserSessionRepository.swift
//  NimbleMedium
//
//  Created by Minh Pham on 30/08/2021.
//

import RxSwift

final class UserSessionRepository: UserSessionRepositoryProtocol {

    private let keychain: KeychainProtocol

    init(keychain: KeychainProtocol) {
        self.keychain = keychain
    }

    func saveUser(_ user: User) -> Completable {
        Completable.create { [weak self] observer in
            do {
                try self?.keychain.set(CodableUser(user: user), for: .user)
            } catch {
                observer(.error(error))
            }
            observer(.completed)
            return Disposables.create()
        }
    }
}
