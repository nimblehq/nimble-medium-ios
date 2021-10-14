//
//  UpdateCurrentUserParameters+Dummy.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 15/10/2021.
//

@testable import NimbleMedium

extension UpdateCurrentUserParameters {

    static let dummy: UpdateCurrentUserParameters = {
        UpdateCurrentUserParameters(username: "", email: "", password: nil, image: "", bio: "")
    }()
}
