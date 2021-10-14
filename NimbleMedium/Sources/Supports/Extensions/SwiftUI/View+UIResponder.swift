//
//  UIApplication+UIResponder.swift
//  NimbleMedium
//
//  Created by Minh Pham on 24/08/2021.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
