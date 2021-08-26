//
//  JSONAPIDecoder+Default.swift
//  NimbleMedium
//
//  Created by Minh Pham on 26/08/2021.
//

import JSONMapper

extension JSONAPIDecoder {

    static let `default`: JSONAPIDecoder = {
        let decoder = JSONAPIDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
