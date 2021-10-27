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
    case getCurrentUser
    case updateCurrentUser(params: UpdateCurrentUserParameters)
}

extension AuthRequestConfiguration: RequestConfiguration {

    var baseURL: String { Constants.API.baseURL }

    var endpoint: String {
        switch self {
        case .login:
            return "/users/login"
        case .signup:
            return "/users"
        case .getCurrentUser, .updateCurrentUser:
            return "/user"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login, .signup:
            return .post
        case .getCurrentUser:
            return .get
        case .updateCurrentUser:
            return .put
        }
    }

    var parameters: Parameters? {
        switch self {
        case let .login(email, password):
            return [
                "user": [
                    "email": email,
                    "password": password
                ]
            ]
        case let .signup(username, email, password):
            return [
                "user": [
                    "username": username,
                    "email": email,
                    "password": password
                ]
            ]
        case .getCurrentUser:
            return nil
        case let .updateCurrentUser(params):
            return ["user": params.dictionary]
        }
    }

    var encoding: ParameterEncoding { URLEncoding.default }
}
