//
//  FollowButton.swift
//  NimbleMedium
//
//  Created by Mark G on 11/10/2021.
//

import SwiftUI

enum FollowButtonStyle {
    case light
}

struct FollowButton: View {

    private let action: () -> Void
    private let isSelected: Bool
    private let style: FollowButtonStyle

    private var textColor: Color {
        switch style {
        case .light:
            return isSelected ? Color(R.color.dark.name) : .gray
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .light:
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
        style: FollowButtonStyle = .light,
        action: @escaping () -> Void
    ) {
        self.style = style
        self.isSelected = isSelected
        self.action = action
    }
}
