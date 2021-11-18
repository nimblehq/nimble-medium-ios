//
//  LabeledAppTextView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 16/11/2021.
//

import SwiftUI

struct LabeledAppTextView: View {

    private var title: String
    private var placeholder: String
    private var text: Binding<String>

    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            Text(title).foregroundColor(.black)
            AppTextView(placeholder: placeholder, text: text)
        }
    }

    init(title: String, placeholder: String, text: Binding<String>) {
        self.title = title
        self.placeholder = placeholder
        self.text = text
    }
}
