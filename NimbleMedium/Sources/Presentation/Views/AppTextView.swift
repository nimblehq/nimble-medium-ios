//
//  AppTextView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 12/10/2021.
//

import SwiftUI

// swiftlint:disable type_contents_order
struct AppTextView: UIViewRepresentable {

    typealias UIViewType = UITextView

    private var configuration: ((UIViewType) -> Void)?
    private var placeholder: String
    private var text: Binding<String>

    private let placeholderTextColor = UIColor.lightGray.withAlphaComponent(0.7)

    init(placeholder: String, text: Binding<String>, configuration: ((UIViewType) -> Void)? = nil) {
        self.placeholder = placeholder
        self.text = text
        self.configuration = configuration
    }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIViewType {
        let textView = UITextView()
        textView.autocapitalizationType = .sentences
        textView.isSelectable = true
        textView.text = placeholder
        textView.textColor = placeholderTextColor
        textView.tintColor = .black
        textView.font = .preferredFont(forTextStyle: UIFont.TextStyle.body)
        textView.delegate = context.coordinator
        textView.layer.cornerRadius = 8.0
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        return textView
    }

    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<Self>) {
        if !text.wrappedValue.isEmpty {
            uiView.text = text.wrappedValue
            uiView.textColor = .black
        }
        configuration?(uiView)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text, placeholder: placeholder, placeholderTextColor: placeholderTextColor)
    }

    class Coordinator: NSObject, UITextViewDelegate {

        var text: Binding<String>
        var placeholder: String
        var placeholderTextColor: UIColor

        init(_ text: Binding<String>, placeholder: String, placeholderTextColor: UIColor) {
            self.text = text
            self.placeholder = placeholder
            self.placeholderTextColor = placeholderTextColor
        }

        func textViewDidChange(_ textView: UITextView) {
            text.wrappedValue = textView.text
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            guard textView.text.isEmpty else { return }
            textView.text = placeholder
            textView.textColor = placeholderTextColor
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            guard textView.textColor == placeholderTextColor else { return }
            textView.text = nil
            textView.textColor = .black
        }
    }
}
