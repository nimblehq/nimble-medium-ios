//
//  KeychainKey.swift
//  NimbleMedium
//
//  Created by Minh Pham on 30/08/2021.
//

protocol KeychainKey {}

extension KeychainKey {

    static var user: Keychain.Key<CodableUser> {
        Keychain.Key(key: "user")
    }
}
