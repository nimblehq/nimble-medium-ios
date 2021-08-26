//
//  AuthenticationRequestConfiguration.swift
//  NimbleMedium
//
//  Created by Minh Pham on 26/08/2021.
//

import Alamofire

enum AuthRequestConfiguration {

    case login(email: String, password: String)
}

extension AuthRequestConfiguration: RequestConfiguration {

    var baseURL: String { Constants.API.baseURL }

    var endpoint: String {
        switch self {
        case .login:
            return "/users/login"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        }
    }

    var parameters: Parameters? {
        switch self {
        case .login(let email, let password):
            return [
                "user": [
                    "email": email,
                    "password": password
                ]
            ]
        }
    }

    var encoding: ParameterEncoding { URLEncoding.default }

    var headers: HTTPHeaders? { nil }

    var interceptor: RequestInterceptor? { nil }
}
