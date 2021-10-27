//
//  UserRequestConfiguration.swift
//  NimbleMedium
//
//  Created by Minh Pham on 27/09/2021.
//

import Alamofire

enum UserRequestConfiguration {

    case profile(username: String)
    case follow(username: String)
    case unfollow(username: String)
}

extension UserRequestConfiguration: RequestConfiguration {

    var baseURL: String { Constants.API.baseURL }

    var endpoint: String {
        switch self {
        case let .profile(username):
            return "/profiles/\(username)"
        case let .unfollow(username),
             let .follow(username):
            return "/profiles/\(username)/follow"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .profile:
            return .get
        case .follow:
            return .post
        case .unfollow:
            return .delete
        }
    }

    var parameters: Parameters? {
        switch self {
        case .profile,
             .follow,
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
