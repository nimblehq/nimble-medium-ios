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
}
