//
//  String+Delimiter.swift
//  NimbleMedium
//
//  Created by Minh Pham on 19/10/2021.
//

import Foundation

extension String {

    func toStringsArray(delimiter: String = ",") -> [String] {
        components(separatedBy: delimiter).map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}
