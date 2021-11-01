//
//  String+Data.swift
//  MVVMRxSwiftDemoTests
//
//  Created by Bliss on 1/7/21.
//

import Foundation

extension String {

    var utf8Data: Data {
        Data(utf8)
    }

    func decoded<T: Decodable>() -> T {

        guard let object: T = utf8Data.decoded() else {
            fatalError("Unable to decode from this resource")
        }

        return object
    }
}
