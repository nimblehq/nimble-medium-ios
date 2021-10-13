//
//  LoginView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 24/08/2021.
//

import SwiftUI
import ToastUI
import Resolver

struct LoginView: View {

    @Environment(\.presentationMode) var presentationMode

    @State private var email = ""
    @State private var errorMessage = ""
    @State private var password = ""
    @State private var errorToast = false
    @State private var loadingToast = false

    @ObservedViewModel var viewModel: LoginViewModelProtocol = Resolver.resolve()

    var body: some View {
        NavigationView {
            contentView
                .onTapGesture { hideKeyboard() }
                .navigationBarTitle(Localizable.loginTitle(), displayMode: .inline)
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
        .accentColor(.white)
        .onReceive(viewModel.output.didLogin) { _ in
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
    var contentView: some View {
        Background {
            VStack(spacing: 15.0) {
                AppTextField(
                    placeholder: Localizable.loginTextFieldEmailPlaceholder(),
                    text: $email,
                    supportEmailKeyboard: true
                )
                AppSecureField(
                    placeholder: Localizable.loginTextFieldPasswordPlaceholder(),
                    text: $password)
                AppMainButton(title: Localizable.actionLoginText()) {
                    hideKeyboard()
                    viewModel.input.didTapLoginButton(email: email, password: password)
                }
                .disabled(email.isEmpty || password.isEmpty || loadingToast)
                Button(
                    action: {
                        presentationMode.wrappedValue.dismiss()
                        viewModel.input.didTapNoAccountButton()
                    }, label: {
                        Text(Localizable.loginNeedAccountTitle())
                            .frame(height: 25.0)
                    }
                )
                .foregroundColor(.green)
            }
            .padding()
        }
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View { LoginView() }
}
#endif
