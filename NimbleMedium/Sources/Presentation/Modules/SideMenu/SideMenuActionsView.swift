//
//  SideMenuActionsView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 23/08/2021.
//

import SwiftUI

struct SideMenuActionsView: View {

    private var factory: ViewModelFactoryProtocol
    private var onSelectOptionItem: (() -> Void)?

    @State private var isAuthenticated = false
    @State private var isShowingLoginScreen = false

    var body: some View {
        VStack(alignment: .leading) {
            if !isAuthenticated {
                SideMenuActionItemView(
                    text: Localizable.menuOptionLogin(),
                    iconName: R.image.iconLogin.name
                ) {
                    onSelectOptionItem?()
                    isShowingLoginScreen.toggle()
                }
                .fullScreenCover(isPresented: $isShowingLoginScreen) {
                    LoginView(viewModel: factory.loginViewModel())
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

    init(factory: ViewModelFactoryProtocol, onSelectOptionItem: (() -> Void)? = nil) {
        self.factory = factory
        self.onSelectOptionItem = onSelectOptionItem
    }
}

#if DEBUG
struct SideMenuActionsView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuActionsView(factory: DependencyFactory())
    }
}
#endif
