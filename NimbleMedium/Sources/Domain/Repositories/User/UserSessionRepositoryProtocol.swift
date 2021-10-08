//
//  UserSessionRepositoryProtocol.swift
//  NimbleMedium
//
//  Created by Minh Pham on 30/08/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol UserSessionRepositoryProtocol: AnyObject {

    func saveUser(_ user: User) -> Completable
    func getCurrentUser() -> Single<User?>
}
