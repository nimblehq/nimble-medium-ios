//
//  LoginView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 24/08/2021.
//

import SwiftUI
import ToastUI

struct LoginView: View {

    @Environment(\.presentationMode) var presentationMode

    @State private var email = ""
    @State private var password = ""
    @State private var loadingToast: Bool = false
    @State private var errorToast: Bool = false
    @State private var errorMessage = ""

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
                        viewModel.input.didTapLoginButton(email: email, password: password)
                    }
                    .disabled(email.isEmpty || password.isEmpty)
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
                .padding()

            }
            .onTapGesture { hideKeyboard() }
            .navigationBarTitle(Localizable.loginTitle(), displayMode: .inline)
            .navigationBarColor(backgroundColor: .green)
            .toolbar { navigationBarLeadingContent }
            .toast(isPresented: $errorToast, dismissAfter: 2.0) {
                ToastView(errorMessage)
            }
            .toast(isPresented: $loadingToast) {
                ToastView(String.empty)
                    .toastViewStyle(IndefiniteProgressToastViewStyle())
            }
        }
        .accentColor(.white)
        .onReceive(viewModel.output.didLogin) { _ in
            presentationMode.wrappedValue.dismiss()
        }
        .onReceive(viewModel.output.errorMessage) {
            errorMessage = $0
            errorToast.toggle()
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

    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let factory = DependencyFactory(networkAPI: NetworkAPI())
        let viewModel = LoginViewModel(factory: factory)
        return LoginView(viewModel: viewModel)
    }
}
#endif
