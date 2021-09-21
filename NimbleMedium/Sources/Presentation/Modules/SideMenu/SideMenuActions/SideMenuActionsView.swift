//
//  SideMenuActionsView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 23/08/2021.
//

import SwiftUI
import RxSwift
import Resolver

struct SideMenuActionsView: View {

    @ObservedViewModel private var viewModel: SideMenuActionsViewModelProtocol = Resolver.resolve()

    // TODO: Update with correct value for isAuthenticated in integrate task
    @State private var isAuthenticated = true
    @State private var isShowingLoginScreen = false
    @State private var isShowingSignupScreen = false

    var body: some View {
        if isAuthenticated {
            authenticatedMenuOptions
        } else {
            unauthenticatedMenuHeader
        }
    }

    var authenticatedMenuOptions: some View {
        VStack(alignment: .leading) {
            SideMenuActionItemView(
                text: Localizable.menuOptionMyProfile(),
                iconName: R.image.iconMyProfile.name
            ) {
                // TODO: Implement this option tap action in the integrate task
            }
        }
    }

    var unauthenticatedMenuHeader: some View {
        VStack(alignment: .leading) {
            SideMenuActionItemView(
                text: Localizable.menuOptionLogin(),
                iconName: R.image.iconLogin.name
            ) {
                viewModel.input.selectLoginOption()
            }
            .fullScreenCover(isPresented: $isShowingLoginScreen) {
                LoginView()
            }

            SideMenuActionItemView(
                text: Localizable.menuOptionSignup(),
                iconName: R.image.iconSignup.name
            ) {
                viewModel.input.selectSignupOption()
            }
            .fullScreenCover(isPresented: $isShowingSignupScreen) {
                SignupView()
            }
        }
        .onReceive(viewModel.output.didSelectLoginOption) {
            isShowingLoginScreen = $0
        }
        .onReceive(viewModel.output.didSelectSignupOption) {
            isShowingSignupScreen = $0
        }
    }
}

#if DEBUG
struct SideMenuActionsView_Previews: PreviewProvider {
    static var previews: some View { SideMenuActionsView() }
}
#endif
