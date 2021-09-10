//
//  DateFormatter+MonthDayYear.swift
//  NimbleMedium
//
//  Created by Mark G on 10/09/2021.
//

import Foundation

extension DateFormatter {

    static let monthDayYear = DateFormatter(with: .monthDayYearDateFormat)

    convenience init(with format: String) {
        self.init()
        dateFormat = format
    }
}
