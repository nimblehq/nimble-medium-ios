//
//  Date+Format.swift
//  NimbleMedium
//
//  Created by Mark G on 13/09/2021.
//

import Foundation

extension Date {

    func format(with formatter: DateFormatter) -> String {
        return formatter.string(from: self)
    }
}
