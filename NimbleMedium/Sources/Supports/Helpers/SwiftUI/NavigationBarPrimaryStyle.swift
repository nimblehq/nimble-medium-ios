//
//  NavigationBarPrimaryStyle.swift
//  NimbleMedium
//
//  Created by Mark G on 14/09/2021.
//

import SwiftUI

struct NavigationBarPrimaryStyle: ViewModifier {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let isBackButtonHidden: Bool

    init(isBackButtonHidden: Bool = false) {
        self.isBackButtonHidden = isBackButtonHidden
    }

    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(backgroundColor: .green)
            .navigationBarBackButtonHidden(true)
            .if(!isBackButtonHidden) { view in
                view.toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(
                            action: { presentationMode.wrappedValue.dismiss() },
                            label: { Image(R.image.backIcon.name) }
                        )
                    }
                }
            }
    }
}
