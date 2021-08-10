//
//  String.swift
//  NimbleMedium
//
//  Created by Mark G on 10/08/2021.
//

extension String {

    static let empty: String = ""
}

extension Optional where Wrapped == String {

    func orEmpty() -> String {
        self ?? .empty
    }
}
