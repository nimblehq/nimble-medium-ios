//
//  LoginView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 24/08/2021.
//

import SwiftUI

struct LoginView: View {

    @Environment(\.presentationMode) var presentationMode

    @State private var email = ""
    @State private var password = ""

    @ObservedViewModel var viewModel: LoginViewModelProtocol

    var body: some View {
        NavigationView {
            Background {
                VStack(spacing: 15.0) {
                    AuthTextFieldView(
                        placeholder: Localizable.loginTextFieldEmailPlaceholder(),
                        text: $email,
                        supportEmailKeyboard: true
                    )
                    AuthSecureFieldView(
                        placeholder: Localizable.loginTextfieldPasswordPlaceholder(),
                        text: $password)
                    AppMainButton(title: Localizable.actionLogin()) {
                        // TODO: Implement in integrate task
                    }
                    Button(
                        action: {
                            // TODO: Implement in integrate task
                        }, label: {
                            Text(Localizable.loginNeedAccountTitle())
                                .frame(height: 25.0)
                        }
                    )
                    .foregroundColor(.green)
                }

            }
            .onTapGesture { hideKeyboard() }
            .navigationBarTitle(Localizable.loginTitle(), displayMode: .inline)
            .navigationBarColor(backgroundColor: .green)
            .toolbar { navigationBarLeadingContent }
        }
        .accentColor(.white)
    }

    var navigationBarLeadingContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(
                action: {
                    presentationMode.wrappedValue.dismiss()
                },
                label: {
                    Image(systemName: SystemImageName.xmark.rawValue)
                }
            )
        }
    }

    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
#endif
