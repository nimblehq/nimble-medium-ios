//
//  AuthenticatedNetworkAPI.swift
//  NimbleMedium
//
//  Created by Minh Pham on 29/09/2021.
//

import Foundation
import Alamofire
import RxSwift

final class AuthenticatedNetworkAPI: AuthenticatedNetworkAPIProtocol {

    private let decoder: JSONDecoder
    private let session: Session

    init(
        decoder: JSONDecoder = .default,
        keychain: KeychainProtocol
    ) {
        self.decoder = decoder
        session = Session(interceptor: AuthenticatedInterceptor(keychain: keychain))
    }

    func performRequest<T>(_ configuration: RequestConfiguration, for type: T.Type) -> Single<T> where T: Decodable {
        request(
            session: session,
            configuration: configuration,
            decoder: decoder
        )
    }
}
