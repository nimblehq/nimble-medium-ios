//
//  AuthenticatedInterceptor.swift
//  NimbleMedium
//
//  Created by Minh Pham on 29/09/2021.
//

import Alamofire
import Foundation

final class AuthenticatedInterceptor: RequestInterceptor {

    private let keychain: KeychainProtocol

    init(keychain: KeychainProtocol) {
        self.keychain = keychain
    }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        if let accessToken = try? keychain.get(.user)?.token {
            request.headers.add(name: "Authorization", value: "Token \(accessToken)")
            completion(.success(request))
        } else {
            completion(.failure(NetworkAPIError.generic))
        }
    }
}
