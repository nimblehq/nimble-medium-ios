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
                    TextField(Localizable.signupTextFieldUsernamePlaceholder(), text: $username)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8.0)
                                .stroke(Color(.lightGray), lineWidth: 1.0)
                        )
                        .accentColor(.black)
                    TextField(Localizable.signupTextFieldEmailPlaceholder(), text: $email)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8.0)
                                .stroke(Color(.lightGray), lineWidth: 1.0)
                        )
                        .keyboardType(.emailAddress)
                        .accentColor(.black)
                    SecureField(Localizable.signupTextFieldPasswordPlaceholder(), text: $password)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8.0)
                                .stroke(Color(.lightGray), lineWidth: 1.0)
                        )
                        .accentColor(.black)
                    Button(
                        action: {
                            // TODO: Implement in integrate task
                        }, label: {
                            Text(Localizable.actionSignup())
                                .frame(width: 100.0, height: 50.0)
                        }
                    )
                    .background(Color.green)
                    .cornerRadius(8.0)
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
