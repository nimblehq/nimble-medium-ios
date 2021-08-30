//
//  JSONDecoder+Default.swift
//  NimbleMedium
//
//  Created by Minh Pham on 26/08/2021.
//
import Foundation

extension JSONDecoder {

    static let `default`: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
