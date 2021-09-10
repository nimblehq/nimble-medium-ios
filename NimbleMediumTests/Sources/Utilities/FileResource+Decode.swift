//
//  FileResource+Decode.swift
//  NimbleMediumTests
//
//  Created by Mark G on 10/09/2021.
//

import Foundation
import Rswift

extension FileResource {

    func decoded<T: Decodable>() -> T {

        guard let url = url(),
              let data = try? Data(contentsOf: url),
              let object: T = data.decoded() else {
            fatalError("Unable to decode from this resource")
        }

        return object
    }
}
