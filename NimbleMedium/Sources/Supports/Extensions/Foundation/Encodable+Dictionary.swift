//
//  Encodable+Dictionary.swift
//  NimbleMedium
//
//  Created by Minh Pham on 18/10/2021.
//

import Foundation

extension Encodable {

    var dictionary: [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments))
            .flatMap { $0 as? [String: Any] } ?? [:]
    }
}
