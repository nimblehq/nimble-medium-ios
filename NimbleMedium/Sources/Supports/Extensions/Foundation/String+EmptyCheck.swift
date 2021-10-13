//
//  String+EmptyCheck.swift
//  NimbleMedium
//
//  Created by Minh Pham on 13/10/2021.
//

import Foundation

extension String {

    func toNilIfEmpty() -> String? {
        self.isEmpty ? nil : self
    }
}
