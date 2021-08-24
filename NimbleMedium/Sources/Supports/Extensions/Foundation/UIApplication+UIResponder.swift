//
//  UIApplication+UIResponder.swift
//  NimbleMedium
//
//  Created by Minh Pham on 24/08/2021.
//

import UIKit

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
