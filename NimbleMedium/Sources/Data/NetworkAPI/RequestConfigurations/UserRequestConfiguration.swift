//
//  UserRequestConfiguration.swift
//  NimbleMedium
//
//  Created by Minh Pham on 27/09/2021.
//

import Alamofire

enum UserRequestConfiguration {

    case profile(username: String)
    case unfollow(username: String)
}

extension UserRequestConfiguration: RequestConfiguration {

    var baseURL: String { Constants.API.baseURL }

    var endpoint: String {
        switch self {
        case .profile(let username):
            return "/profiles/\(username)"
        case .unfollow(let username):
            return "/profiles/\(username)/follow"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .profile:
            return .get
        case .unfollow:
            return .delete
        }
    }

    var parameters: Parameters? {
        switch self {
        case .profile,
             .unfollow:
            return nil
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .profile:
            return URLEncoding.queryString
        default:
            return URLEncoding.default
        }
    }
}
