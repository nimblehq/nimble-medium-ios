//
//  AppTextField.swift
//  NimbleMedium
//
//  Created by Minh Pham on 27/08/2021.
//

import SwiftUI

struct AppTextField: View {

    private var placeholder: String
    private var text: Binding<String>
    private var emailKeyboard: Bool
    private var autoCapitalization: Bool

    var body: some View {
        TextField(placeholder, text: text)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8.0)
                    .stroke(Color(.lightGray), lineWidth: 1.0)
            )
            .keyboardType(emailKeyboard ? .emailAddress : .default)
            .accentColor(.black)
            .autocapitalization(autoCapitalization ? .sentences : .none)
    }

    init(placeholder: String, text: Binding<String>, emailKeyboard: Bool = false, autoCapitalization: Bool = true) {
        self.placeholder = placeholder
        self.text = text
        self.emailKeyboard = emailKeyboard
        self.autoCapitalization = autoCapitalization
    }
}
