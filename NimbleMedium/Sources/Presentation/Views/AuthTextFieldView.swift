//
//  AuthTextFieldView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 27/08/2021.
//

import SwiftUI

struct AuthTextFieldView: View {

    private var placeHolderText: String
    private var text: Binding<String>
    private var supportEmailKeyboard: Bool

    var body: some View {
        TextField(placeHolderText, text: text)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8.0)
                    .stroke(Color(.lightGray), lineWidth: 1.0)
            )
            .keyboardType(supportEmailKeyboard ? .emailAddress : .default)
            .accentColor(.black)
    }

    init(placeHolderText: String, text: Binding<String>, supportEmailKeyboard: Bool = false) {
        self.placeHolderText = placeHolderText
        self.text = text
        self.supportEmailKeyboard = supportEmailKeyboard
    }
}
