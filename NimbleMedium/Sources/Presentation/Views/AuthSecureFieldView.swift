//
//  AuthSecureFieldView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 27/08/2021.
//

import SwiftUI

struct AuthSecureFieldView: View {

    private var placeHolderText: String
    private var text: Binding<String>

    var body: some View {
        SecureField(placeHolderText, text: text)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8.0)
                    .stroke(Color(.lightGray), lineWidth: 1.0)
            )
            .accentColor(.black)
    }

    init(placeHolderText: String, text: Binding<String>) {
        self.placeHolderText = placeHolderText
        self.text = text
    }
}
