//
//  SideMenuActionItemView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 23/08/2021.
//

import SwiftUI

struct SideMenuActionItemView: View {
    var text: String
    var iconName: String
    var action: (() -> Void)
    
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
}
