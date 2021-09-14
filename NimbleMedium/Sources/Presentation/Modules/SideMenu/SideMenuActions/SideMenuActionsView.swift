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

    @State private var isAuthenticated = false
    @State private var isShowingLoginScreen = false
    @State private var isShowingSignupScreen = false

    var body: some View {
        VStack(alignment: .leading) {
            if !isAuthenticated {
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
