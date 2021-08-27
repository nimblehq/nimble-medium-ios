//
//  NimbleMediumMainButton.swift
//  NimbleMedium
//
//  Created by Minh Pham on 27/08/2021.
//

import SwiftUI

struct AppMainButton: View {

    private var title: String
    private var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title).frame(width: 100.0, height: 50.0)
        }
        .background(Color.green)
        .cornerRadius(8.0)
    }

    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
}
