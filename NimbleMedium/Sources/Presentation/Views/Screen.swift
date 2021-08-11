//
//  Screen.swift
//  NimbleMedium
//
//  Created by Mark G on 10/08/2021.
//

import SwiftUI

struct Screen<V1: ToolbarContent, V2: View>: View {

    private let content: TupleView<(NavigationBar<V1>, V2)>

    // swiftlint:disable type_contents_order
    init(@ViewBuilder content: () -> TupleView<(NavigationBar<V1>, V2)>) {
        self.content = content()
    }

    var body: some View {
        let navigationBar = content.value.0
        let body = content.value.1
        
        return NavigationView {
            body
                .navigationBarTitle(
                    navigationBar.title ?? .empty,
                    displayMode: .inline
                )
                .navigationBarColor(
                    backgroundColor: .green,
                    titleColor: .white
                )
                .ifNotNil(navigationBar.content) { view, toolbarContent in
                    view.toolbar { toolbarContent }
                }
        }
    }
}
