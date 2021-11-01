//
//  SideMenuActionsView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 23/08/2021.
//

import Resolver
import RxSwift
import SwiftUI

struct SideMenuActionsView: View {

    @ObservedViewModel private var viewModel: SideMenuActionsViewModelProtocol = Resolver.resolve()

    @Injected private var loginViewModel: LoginViewModelProtocol
    @Injected private var signupViewModel: SignupViewModelProtocol
    @Injected private var homeViewModel: HomeViewModelProtocol

    @EnvironmentObject private var userSessionViewModel: UserSessionViewModel

    @State private var isAuthenticated = false
    @State private var isShowingLoginScreen = false
    @State private var isShowingSignupScreen = false
    @State private var isShowingMyProfileScreen = false
    @State private var showLogoutConfirmationAlert = false

    @ViewBuilder var contentsView: some View {
        if isAuthenticated {
            authenticatedMenuOptions
        } else {
            unauthenticatedMenuHeader
        }
    }
    
    var body: some View {
        contentsView
            .onAppear {
                viewModel.input.bindData(
                    loginViewModel: loginViewModel,
                    signupViewModel: signupViewModel,
                    homeViewModel: homeViewModel,
                    userSessionViewModel: userSessionViewModel
                )
            }
            .bind(userSessionViewModel.output.isAuthenticated, to: _isAuthenticated)
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
                showLogoutConfirmationAlert.toggle()
            }
            .alert(isPresented: $showLogoutConfirmationAlert) {
                Alert(
                    title: Text(Localizable.popupConfirmLogoutTitle()),
                    primaryButton: .destructive(
                        Text(Localizable.actionConfirmText()), action: { viewModel.input.selectLogoutOption() }
                    ),
                    secondaryButton: .default(Text(Localizable.actionCancelText()))
                )
            }
        }
        .bind(viewModel.output.didSelectMyProfileOption, to: _isShowingMyProfileScreen)
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
    }
}

#if DEBUG
    struct SideMenuActionsView_Previews: PreviewProvider {
        static var previews: some View { SideMenuActionsView() }
    }
#endif
