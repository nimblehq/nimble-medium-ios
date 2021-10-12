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

    func getCurrentUser() -> Single<User?> {
        Single.create { [weak self] single in
            do {
                let user = try self?.keychain.get(.user)
                single(.success(user))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }

    func removeCurrentUser() -> Completable {
        Completable.create { [weak self] observer in
            do {
                try self?.keychain.remove(.user)
                observer(.completed)
            } catch {
                observer(.error(error))
            }

            return Disposables.create()
        }
    }

    func saveUser(_ user: User) -> Completable {
        Completable.create { [weak self] observer in
            do {
                try self?.keychain.set(CodableUser(user: user), for: .user)
                observer(.completed)
            } catch {
                observer(.error(error))
            }

            return Disposables.create()
        }
    }
}
