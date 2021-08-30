//
//  SignupView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 24/08/2021.
//

import SwiftUI

struct SignupView: View {

    @Environment(\.presentationMode) var presentationMode

    @State private var email = ""
    @State private var password = ""
    @State private var username = ""

    private var viewModel: SignupViewModelProtocol

    // swiftlint:disable closure_body_length
    var body: some View {
        NavigationView {
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
                        // TODO: Implement in integrate task
                    }
                    Button(
                        action: {
                            // TODO: Implement in integrate task
                        }, label: {
                            Text(Localizable.signupHaveAccountTitle())
                                .frame(height: 25.0)
                        }
                    )
                    .foregroundColor(.green)
                }
            }
            .onTapGesture { hideKeyboard() }
            .navigationBarTitle(Localizable.signupTitle(), displayMode: .inline)
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

    init(viewModel: SignupViewModelProtocol) {
        self.viewModel = viewModel
    }
}

#if DEBUG
struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(viewModel: SignupViewModel())
    }
}
#endif
