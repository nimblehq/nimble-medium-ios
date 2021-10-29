//
//  ArticleInputFields.swift
//  NimbleMedium
//
//  Created by Minh Pham on 29/10/2021.
//

import SwiftUI

struct ArticleInputFields: View {

    private let fields: [FieldType]

    var body: some View {
        VStack(spacing: 15.0) {
            ForEach(fields, id: \.self) {
                switch $0 {
                case .textField(let placeholder, let text, let fontSize):
                    if let fontSize = fontSize {
                        AppTextField(placeholder: placeholder, text: text)
                            .font(.system(size: fontSize))
                    } else {
                        AppTextField(placeholder: placeholder, text: text)
                    }
                case .textView(let placeholder, let text):
                    AppTextView(placeholder: placeholder, text: text)
                        .frame(height: 200.0, alignment: .leading)
                }
            }
        }
    }

    init(fields: [FieldType]) {
        self.fields = fields
    }
}
