//
//  SideMenuActionsView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 23/08/2021.
//

import SwiftUI
import RxSwift

struct SideMenuActionsView: View {

    @ObservedViewModel private var viewModel: SideMenuActionsViewModelProtocol

    @State private var isAuthenticated = false
    @State private var isShowingLoginScreen = false

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
                    LoginView(viewModel: viewModel.output.loginViewModel)
                }

                SideMenuActionItemView(
                    text: Localizable.menuOptionSignup(),
                    iconName: R.image.iconSignup.name
                ) {
                    print("Signup button was tapped")
                }
            }
        }
        .onReceive(viewModel.output.didSelectLoginOption) {
            isShowingLoginScreen = $0
        }
    }

    init(viewModel: SideMenuActionsViewModelProtocol) {
        self.viewModel = viewModel
    }
}

#if DEBUG
struct SideMenuActionsView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuActionsView(viewModel: SideMenuActionsViewModel(factory: DependencyFactory()))
    }
}
#endif
