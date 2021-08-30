//
//  UserSessionRepositoryProtocol.swift
//  NimbleMedium
//
//  Created by Minh Pham on 30/08/2021.
//

import RxSwift

protocol UserSessionRepositoryProtocol: AnyObject {

    func saveUser(_ user: APIUser) -> Completable
}
