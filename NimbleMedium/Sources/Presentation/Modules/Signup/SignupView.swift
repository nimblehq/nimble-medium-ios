//
//  SignupView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 24/08/2021.
//

import SwiftUI
import ToastUI

struct SignupView: View {

    @Environment(\.presentationMode) var presentationMode

    @State private var email = ""
    @State private var errorMessage = ""
    @State private var password = ""
    @State private var username = ""
    @State private var errorToast = false
    @State private var loadingToast = false

    private var viewModel: SignupViewModelProtocol

    var body: some View {
        NavigationView { navBackgroundContent }
        .accentColor(.white)
        .onReceive(viewModel.output.didSignup) { _ in
            presentationMode.wrappedValue.dismiss()
        }
        .onReceive(viewModel.output.errorMessage) { _ in
            errorMessage = Localizable.errorGeneric()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { errorToast.toggle() }
        }
        .onReceive(viewModel.output.isLoading) {
            loadingToast = $0
        }
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

    // swiftlint:disable closure_body_length
    var navBackgroundContent: some View {
        Background {
            VStack(spacing: 15.0) {
                AuthTextFieldView(
                    placeholder: Localizable.signupTextFieldUsernamePlaceholder(),
                    text: $username
                )
                AuthTextFieldView(
                    placeholder: Localizable.signupTextFieldEmailPlaceholder(),
                    text: $email,
                    supportEmailKeyboard: true
                )
                AuthSecureFieldView(
                    placeholder: Localizable.signupTextFieldPasswordPlaceholder(),
                    text: $password)
                AppMainButton(title: Localizable.actionSignup()) {
                    hideKeyboard()
                    viewModel.input.didTapSignupButton(username: username, email: email, password: password)
                }
                .disabled(username.isEmpty || email.isEmpty || password.isEmpty || loadingToast)
                Button(
                    action: {
                        presentationMode.wrappedValue.dismiss()
                        viewModel.input.didTapHaveAccountButton()
                    }, label: {
                        Text(Localizable.signupHaveAccountTitle())
                            .frame(height: 25.0)
                    }
                )
                .foregroundColor(.green)
            }
            .padding()

        }
        .onTapGesture { hideKeyboard() }
        .navigationBarTitle(Localizable.signupTitle(), displayMode: .inline)
        .navigationBarColor(backgroundColor: .green)
        .toolbar { navigationBarLeadingContent }
        .toast(isPresented: $errorToast, dismissAfter: 3.0) {
            ToastView(errorMessage) { } background: {
                Color.clear
            }
        }
        .toast(isPresented: $loadingToast) {
            ToastView(String.empty) { }
                .toastViewStyle(IndefiniteProgressToastViewStyle())
        }
    }

    init(viewModel: SignupViewModelProtocol) {
        self.viewModel = viewModel
    }
}

#if DEBUG
struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SignupViewModel(factory: App().factory)
        return SignupView(viewModel: viewModel)
    }
}
#endif
