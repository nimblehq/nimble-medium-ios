//
//  UserRepositoryProtocol.swift
//  NimbleMedium
//
//  Created by Minh Pham on 27/09/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol UserRepositoryProtocol: AnyObject {

    func getUserProfile(username: String) -> Single<Profile>
    
    func unfollow(username: String) -> Completable
}
