//
//  AppSecureField.swift
//  NimbleMedium
//
//  Created by Minh Pham on 27/08/2021.
//

import SwiftUI

struct AppSecureField: View {

    private var placeholder: String
    private var text: Binding<String>

    var body: some View {
        SecureField(placeholder, text: text)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8.0)
                    .stroke(Color(.lightGray), lineWidth: 1.0)
            )
            .accentColor(.black)
    }

    init(placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self.text = text
    }
}
