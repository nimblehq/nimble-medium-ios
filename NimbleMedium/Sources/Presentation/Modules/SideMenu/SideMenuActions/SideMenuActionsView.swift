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

    @Injected private var loginViewModel: LoginViewModelProtocol
    @Injected private var signupViewModel: SignupViewModelProtocol
    @Injected private var homeViewModel: HomeViewModelProtocol

    @State private var isAuthenticated = false
    @State private var isShowingLoginScreen = false
    @State private var isShowingSignupScreen = false
    @State private var isShowingMyProfileScreen = false

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
                viewModel.input.selectMyProfileOption()
            }
            .fullScreenCover(isPresented: $isShowingMyProfileScreen) {
                NavigationView {
                    UserProfileView()
                }
                .accentColor(.white)
            }

            SideMenuActionItemView(
                text: Localizable.menuOptionLogout(),
                iconName: R.image.iconLogout.name
            ) {
                // TODO: Implement this option tap action in the integrate task
            }
        }
        .bind(viewModel.output.didSelectMyProfileOption, to: _isShowingMyProfileScreen)
        .bind(viewModel.output.isAuthenticated, to: _isAuthenticated)
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
        .bind(viewModel.output.didSelectLoginOption, to: _isShowingLoginScreen)
        .bind(viewModel.output.didSelectSignupOption, to: _isShowingSignupScreen)
        .bind(viewModel.output.isAuthenticated, to: _isAuthenticated)
    }

    init() {
        viewModel.input.bindData(
            loginViewModel: loginViewModel,
            signupViewModel: signupViewModel,
            homeViewModel: homeViewModel
        )
    }
}

#if DEBUG
struct SideMenuActionsView_Previews: PreviewProvider {
    static var previews: some View { SideMenuActionsView() }
}
#endif
