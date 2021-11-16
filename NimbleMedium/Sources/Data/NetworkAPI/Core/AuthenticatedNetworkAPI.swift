//
//  AuthenticatedNetworkAPI.swift
//  NimbleMedium
//
//  Created by Minh Pham on 29/09/2021.
//

import Alamofire
import Foundation
import RxSwift

final class AuthenticatedNetworkAPI: AuthenticatedNetworkAPIProtocol {

    private let decoder: JSONDecoder
    private let session: Session

    init(
        decoder: JSONDecoder = .default,
        keychain: KeychainProtocol
    ) {
        self.decoder = decoder
        let composite = Interceptor(
            interceptors: [
                CommonInterceptor(),
                AuthenticatedInterceptor(keychain: keychain)
            ]
        )
        session = Session(interceptor: composite)
    }

    func performRequest<T>(_ configuration: RequestConfiguration, for type: T.Type) -> Single<T> where T: Decodable {
        request(
            session: session,
            configuration: configuration,
            decoder: decoder
        )
    }

    func performRequest(_ configuration: RequestConfiguration) -> Completable {
        request(
            session: session,
            configuration: configuration,
            decoder: decoder
        )
    }
}
