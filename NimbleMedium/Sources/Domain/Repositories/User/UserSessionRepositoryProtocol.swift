//
//  UserSessionRepositoryProtocol.swift
//  NimbleMedium
//
//  Created by Minh Pham on 30/08/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol UserSessionRepositoryProtocol: AnyObject {

    func getCurrentUser() -> Single<User?>
    func removeCurrentUser() -> Completable
    func saveUser(_ user: User) -> Completable
}
