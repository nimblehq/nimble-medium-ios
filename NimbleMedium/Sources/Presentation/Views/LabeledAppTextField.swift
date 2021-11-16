//
//  LabeledAppTextField.swift
//  NimbleMedium
//
//  Created by Minh Pham on 16/11/2021.
//

import SwiftUI

struct LabeledAppTextField: View {

    private var title: String
    private var placeholder: String
    private var text: Binding<String>
    private var emailKeyboard: Bool
    private var autoCapitalization: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            Text(title).foregroundColor(.black)
            AppTextField(
                placeholder: placeholder,
                text: text,
                emailKeyboard: emailKeyboard,
                autoCapitalization: autoCapitalization
            )
        }
    }

    init(title: String, placeholder: String, text: Binding<String>, emailKeyboard: Bool = false, autoCapitalization: Bool = true) {
        self.title = title
        self.placeholder = placeholder
        self.text = text
        self.emailKeyboard = emailKeyboard
        self.autoCapitalization = autoCapitalization
    }
}
