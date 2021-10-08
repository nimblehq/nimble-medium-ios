//
//  UserRequestConfiguration.swift
//  NimbleMedium
//
//  Created by Minh Pham on 27/09/2021.
//

import Alamofire

enum UserRequestConfiguration {

    case profile(username: String)
}

extension UserRequestConfiguration: RequestConfiguration {

    var baseURL: String { Constants.API.baseURL }

    var endpoint: String {
        switch self {
        case .profile(let username):
            return "/profiles/\(username)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .profile:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .profile:
            return nil
        }
    }

    var encoding: ParameterEncoding { URLEncoding.queryString }
}
