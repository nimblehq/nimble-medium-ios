//
//  NavigationBarModifier.swift
//  NimbleMedium
//
//  Created by Mark G on 10/08/2021.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {

    var backgroundColor: Color
    var titleColor: Color

    init(backgroundColor: Color = .clear, titleColor: Color = .white) {
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = backgroundColor.uiColor
        coloredAppearance.titleTextAttributes = [
            .foregroundColor: titleColor.uiColor
        ]
        coloredAppearance.largeTitleTextAttributes = [
            .foregroundColor: titleColor.uiColor
        ]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }

    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                GeometryReader { geometry in
                    self.backgroundColor
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

extension View {

    func navigationBarColor(
        backgroundColor: Color = .clear,
        titleColor: Color = .white) -> some View {
        self.modifier(
            NavigationBarModifier(
                backgroundColor: backgroundColor,
                titleColor: titleColor
            )
        )
    }
}
