//
//  SignupView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 24/08/2021.
//

import SwiftUI

struct SignupView: View {

    @State private var email = ""
    @State private var password = ""
    @State private var username = ""

    private let viewModel: SignupViewModelProtocol

    // swiftlint:disable type_contents_order
    init(viewModel: SignupViewModelProtocol) {
        self.viewModel = viewModel
    }

    // swiftlint:disable closure_body_length
    var body: some View {
        NavigationView {
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
            .padding()
            .navigationTitle(Localizable.signupTitle())
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(backgroundColor: .green)
            .toolbar { navigationBarLeadingContent }
        }
        .accentColor(.white)
        .onTapGesture { hideKeyboard() }
    }

    var navigationBarLeadingContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(
                action: {
                    // TODO: Implement in integrate task
                },
                label: {
                    Image(systemName: SystemImageName.xmark.rawValue)
                }
            )
        }
    }
}

#if DEBUG
struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SignupViewModel()
        return SignupView(viewModel: viewModel)
    }
}
#endif
