//
//  AppTextView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 12/10/2021.
//

import Introspect
import SwiftUI

struct AppTextView: View {

    @Binding private var text: String

    private let placeholder: String
    private var delegateResponder: DelegateResponder

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color(.label))
                    .padding(.top, 10.0)
                    .padding(.leading, 5.0)
            }
            TextEditor(text: $text)
                .opacity(text.isEmpty ? 0.7 : 1.0)
                .introspectTextView {
                    $0.delegate = delegateResponder
                }
                .accentColor(.black)
        }
        .padding([.leading, .trailing], 8.0)
        .overlay(
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(Color(.lightGray), lineWidth: 1.0)
        )
    }

    init(placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        _text = text
        delegateResponder = .init(text: text, shouldEndEditing: true)
    }

    func shouldEndEditing(_ bool: Bool) -> Self {
        var view = self
        view.delegateResponder = .init(
            text: view.$text,
            shouldEndEditing: bool
        )

        return view
    }
}

extension AppTextView {

    class DelegateResponder: NSObject, UITextViewDelegate {

        let text: Binding<String>
        let shouldEndEditing: Bool

        init(text: Binding<String>, shouldEndEditing: Bool) {
            self.text = text
            self.shouldEndEditing = shouldEndEditing
        }

        func textViewDidChange(_ textView: UITextView) {
            text.wrappedValue = textView.text
        }

        func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
            shouldEndEditing
        }
    }
}
