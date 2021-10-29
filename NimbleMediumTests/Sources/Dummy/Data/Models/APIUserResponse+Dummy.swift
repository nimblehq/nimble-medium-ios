//
//  APIUserResponse+Dummy.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 29/09/2021.
//

@testable import NimbleMedium

extension APIUserResponse {

    static let dummy: APIUserResponse = {
        R.file.userJson.decoded()
    }()

    static func dummy(with username: String) -> APIUserResponse {
        """
        {
          "user": {
            "email": "jake@jake.jake",
            "token": "jwt.token.here",
            "username": "\(username)",
            "bio": "I work at statefarm",
            "image": null
          }
        }
        """.decoded()
    }
}
