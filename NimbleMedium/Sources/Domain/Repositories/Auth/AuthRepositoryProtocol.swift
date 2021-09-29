//
//  AuthRepositoryProtocol.swift
//  NimbleMedium
//
//  Created by Minh Pham on 26/08/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol AuthRepositoryProtocol: AnyObject {

    func getCurrentUser() -> Single<User>

    func login(email: String, password: String) -> Single<User>

    func signup(username: String, email: String, password: String) -> Single<User>
}
