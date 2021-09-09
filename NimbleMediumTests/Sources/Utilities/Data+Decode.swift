//
//  Data+Decode.swift
//  NimbleMedium
//
//  Created by Bliss on 1/7/21.
//
//  swiftlint:disable force_try

import Foundation

@testable import NimbleMedium

extension Data {

    func decode<T: Decodable>(with type: T.Type) -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(.iso8601Full)
        return try! decoder.decode(T.self, from: self)
    }

    func decoded<T: Decodable>() -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(.iso8601Full)
        return try! decoder.decode(T.self, from: self)
    }

    func convertToDictionary() -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
