//
//  FieldType.swift
//  NimbleMedium
//
//  Created by Minh Pham on 29/10/2021.
//

import SwiftUI

enum FieldType: Hashable {

    case textField(placeholder: String, text: Binding<String>, fontSize: CGFloat? = nil)
    case textView(placeholder: String, text: Binding<String>)

    static func == (lhs: FieldType, rhs: FieldType) -> Bool {
        switch (lhs, rhs) {
        case let (.textField(aa1, aa2, aa3), .textField(bb1, bb2, bb3)):
            return aa1 == bb1 && aa2.wrappedValue == bb2.wrappedValue && aa3 == bb3
        case let (.textView(aa1, aa2), .textView(bb1, bb2)):
            return aa1 == bb1 && aa2.wrappedValue == bb2.wrappedValue
        default:
            return false
        }
    }

    func hash(into hasher: inout Hasher) {}
}
