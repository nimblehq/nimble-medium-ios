//
//  MenuOptionButtonStyle.swift
//  NimbleMedium
//
//  Created by Minh Pham on 23/08/2021.
//

import SwiftUI

struct MenuOptionButtonStyle: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(configuration.isPressed ? .green : .black)
            .background(configuration.isPressed ? Color.green.opacity(0.4) : Color.clear)
    }
}
