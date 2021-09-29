//
//  AuthenticationRequestConfiguration.swift
//  NimbleMedium
//
//  Created by Minh Pham on 26/08/2021.
//

import Alamofire

enum AuthRequestConfiguration {

    case login(email: String, password: String)
    case signup(username: String, email: String, password: String)
    case user
}

extension AuthRequestConfiguration: RequestConfiguration {

    var baseURL: String { Constants.API.baseURL }

    var endpoint: String {
        switch self {
        case .login:
            return "/users/login"
        case .signup, .user:
            return "/users"

        }
    }

    var method: HTTPMethod {
        switch self {
        case .login, .signup:
            return .post
        case .user:
            return .get
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
        case .signup(let username, let email, let password):
            return [
                "user": [
                    "username": username,
                    "email": email,
                    "password": password
                ]
            ]
        case .user:
            return nil
        }
    }

    var encoding: ParameterEncoding { URLEncoding.default }
}
