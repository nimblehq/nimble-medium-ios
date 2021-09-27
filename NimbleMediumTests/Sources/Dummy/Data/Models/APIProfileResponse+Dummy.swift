//
//  APIProfileResponse+Dummy.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 27/09/2021.
//

@testable import NimbleMedium

extension APIProfileResponse {

    static let dummy: APIProfileResponse = {
        R.file.profileJson.decoded()
    }()
}
