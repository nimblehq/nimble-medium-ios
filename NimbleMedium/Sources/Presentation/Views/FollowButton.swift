//
//  FollowButton.swift
//  NimbleMedium
//
//  Created by Mark G on 11/10/2021.
//

import SwiftUI

struct FollowButton: View {

    private let action: () -> Void
    private let isSelected: Bool
    private let style: Style

    private var textColor: Color {
        switch style {
        case .light:
            return isSelected ? Color(R.color.dark.name) : .gray
        case .dark:
            return isSelected ? Color(R.color.dark.name) : Color(R.color.semiLightGray.name)
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .light, .dark:
            return isSelected ? Color(R.color.lightGray.name) : .clear
        }
    }

    private var title: String {
        isSelected ? Localizable.followButtonSelectedTitle() : Localizable.followButtonNormalTitle()
    }

    var body: some View {
        Button(action: {}, label: {
            Text(title)
                .foregroundColor(textColor)
        })
        .frame(height: 30.0)
        .padding(.horizontal, 8.0)
        .background(backgroundColor)
        .cornerRadius(4.0)
        .overlay(
            RoundedRectangle(cornerRadius: 4.0)
                .stroke(textColor, lineWidth: 1.0)
        )
    }

    init(
        isSelected: Bool,
        style: Style = .light,
        action: @escaping () -> Void
    ) {
        self.style = style
        self.isSelected = isSelected
        self.action = action
    }
}

// MARK: - Style

extension FollowButton {

    enum Style {

        case light
        case dark
    }
}
