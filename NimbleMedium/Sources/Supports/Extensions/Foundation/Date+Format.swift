//
//  Date+Format.swift
//  NimbleMedium
//
//  Created by Mark G on 13/09/2021.
//

import Foundation

extension Date {

    func format(_ format: String) -> String {
        let formatter = DateFormatter(with: format)
        return formatter.string(from: self)
    }
}
