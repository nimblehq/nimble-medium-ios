//
//  SideMenuActionsView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 23/08/2021.
//

import SwiftUI

struct SideMenuActionsView: View {

    @State private var isAuthenticated = false

    var body: some View {
        VStack(alignment: .leading) {
            if !isAuthenticated {
                SideMenuActionItemView(
                    text: Localizable.menuOptionLogin(),
                    iconName: R.image.iconLogin.name
                ) {
                    print("Login button was tapped")
                }
                SideMenuActionItemView(
                    text: Localizable.menuOptionSignup(),
                    iconName: R.image.iconSignup.name
                ) {
                    print("Signup button was tapped")
                }
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
