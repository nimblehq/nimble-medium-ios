//
//  Data+Decode.swift
//  NimbleMedium
//
//  Created by Bliss on 1/7/21.
//

import Foundation

@testable import NimbleMedium

extension Data {

    func decoded<T: Decodable>() -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(.iso8601Full)
        return try? decoder.decode(T.self, from: self)
    }
}
