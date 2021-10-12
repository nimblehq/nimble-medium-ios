//
//  AppTextFieldView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 27/08/2021.
//

import SwiftUI

struct AppTextFieldView: View {

    private var placeholder: String
    private var text: Binding<String>
    private var supportEmailKeyboard: Bool

    var body: some View {
        TextField(placeholder, text: text)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8.0)
                    .stroke(Color(.lightGray), lineWidth: 1.0)
            )
            .keyboardType(supportEmailKeyboard ? .emailAddress : .default)
            .accentColor(.black)
    }

    init(placeholder: String, text: Binding<String>, supportEmailKeyboard: Bool = false) {
        self.placeholder = placeholder
        self.text = text
        self.supportEmailKeyboard = supportEmailKeyboard
    }
}
