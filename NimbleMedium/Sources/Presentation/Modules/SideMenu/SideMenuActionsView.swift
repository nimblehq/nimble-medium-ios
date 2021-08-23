//
//  SideMenuActionsView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 23/08/2021.
//

import SwiftUI

struct SideMenuActionsView: View {

    @State private var unAuthenticated = true

    var body: some View {
        VStack(alignment: .leading) {
            if unAuthenticated {
                Button(
                    action: {
                        print("Login button was tapped")
                    }, label: {
                        HStack(spacing: 10) {
                            Image( "icon-login").resizable()
                                .frame(width: 25.0, height: 25.0)
                            Text(Localizable.menuOptionLogin()).foregroundColor(Color.black)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        }
                    }
                ).buttonStyle(MenuOptionButtonStyle())
            }

        }
    }
}

#if DEBUG
struct SideMenuActionsView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuActionsView()
    }
}
#endif
