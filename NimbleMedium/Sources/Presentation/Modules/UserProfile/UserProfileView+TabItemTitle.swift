//
//  UserProfileView+TabItemTitle.swift
//  NimbleMedium
//
//  Created by Mark G on 05/10/2021.
//

import SwiftUI
import PagerTabStripView

extension UserProfileView {

    class NavTabViewTheme: ObservableObject {
        @Published var textColor = Color.gray
    }

    struct TabItemTitle: View, PagerTabViewDelegate {

        let title: String

        @ObservedObject fileprivate var theme = NavTabViewTheme()

        var body: some View {
            VStack {
                Spacer()
                Text(title)
                    .foregroundColor(theme.textColor)
                    .font(.subheadline)
                Spacer()
                Divider()
                    .frame(height: 1)
                    .background(Color(R.color.lightGray.name))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }

        init(_ title: String) {
            self.title = title
        }

        func setState(state: PagerTabViewState) {
            switch state {
            case .selected:
                theme.textColor = .green
            default:
                theme.textColor = .gray
            }
        }
    }
}
