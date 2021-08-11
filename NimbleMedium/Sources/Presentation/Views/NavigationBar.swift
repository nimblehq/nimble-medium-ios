//
//  NavigationBar.swift
//  NimbleMedium
//
//  Created by Mark G on 11/08/2021.
//

import SwiftUI

struct NavigationBar<Content: ToolbarContent>: View {

    let title: String?
    let content: Content?

    // swiftlint:disable type_contents_order
    init(
        title: String? = nil,
        @ToolbarContentBuilder content: () -> Content
    ) {
        self.title = title
        self.content = content()
    }

    init(title: String? = nil) where Content == Never {
        self.title = title
        self.content = nil
    }

    var body: some View {
        EmptyView()
    }
}
