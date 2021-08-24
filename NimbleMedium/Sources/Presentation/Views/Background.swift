//
//  Background.swift
//  NimbleMedium
//
//  Created by Minh Pham on 24/08/2021.
//

import SwiftUI

struct Background<Content: View>: View {

    private var content: Content

    var body: some View {
        Color.white
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .overlay(content)
    }

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
}
