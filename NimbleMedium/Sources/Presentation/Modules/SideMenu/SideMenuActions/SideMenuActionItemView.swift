//
//  SideMenuActionItemView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 23/08/2021.
//

import SwiftUI

struct SideMenuActionItemView: View {

    private var text: String
    private var iconName: String
    private var action: (() -> Void)

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10.0) {
                Image(iconName)
                    .resizable()
                    .frame(width: 25.0, height: 25.0)
                Text(text)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }.contentShape(Rectangle())
        }.buttonStyle(MenuOptionButtonStyle())
    }

    init(text: String, iconName: String, action: @escaping (() -> Void)) {
        self.text = text
        self.iconName = iconName
        self.action = action
    }
}
