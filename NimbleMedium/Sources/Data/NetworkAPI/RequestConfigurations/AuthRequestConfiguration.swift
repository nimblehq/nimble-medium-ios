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
    case updateCurrentUser(
        username: String,
        email: String,
        password: String?,
        image: String?,
        bio: String?
    )
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
        case .getCurrentUser:
            return nil
        case .updateCurrentUser(
                let username,
                let email,
                let password,
                let image,
                let bio
        ):
            return [
                "user": [
                    "username": username,
                    "email": email,
                    "password": password,
                    "image": image,
                    "bio": bio
                ].compactMapValues { $0 }
            ]
        }
    }

    var encoding: ParameterEncoding { URLEncoding.default }
}
