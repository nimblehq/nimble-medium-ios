//
//  Screen.swift
//  NimbleMedium
//
//  Created by Mark G on 10/08/2021.
//

import SwiftUI

struct Screen<Content>: View where Content: View {

    private let content: Content
    private let title: String?
    private let titleColor: Color

    // swiftlint:disable type_contents_order
    init(title: String? = nil,
         titleColor: Color = .white,
         @ViewBuilder content: () -> Content) {
        self.content = content()
        self.title = title
        self.titleColor = titleColor
    }

    var body: some View {
        NavigationView {
            content
                .navigationBarTitle(
                    title ?? EMPTY_STRING,
                    displayMode: .inline
                )
                .navigationBarColor(
                    backgroundColor: .green,
                    titleColor: titleColor
                )
        }
    }
}
