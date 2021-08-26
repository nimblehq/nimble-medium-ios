//
//  AuthRepositoryProtocol.swift
//  NimbleMedium
//
//  Created by Minh Pham on 26/08/2021.
//

import RxSwift

protocol AuthRepositoryProtocol: AnyObject {

    func login(email: String, password: String) -> Single<User>
}
