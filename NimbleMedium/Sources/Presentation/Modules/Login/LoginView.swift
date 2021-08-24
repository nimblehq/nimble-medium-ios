//
//  LoginView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 24/08/2021.
//

import SwiftUI

struct LoginView: View {

    @State private var email = ""
    @State private var password = ""

    private let viewModel: LoginViewModelProtocol

    // swiftlint:disable type_contents_order
    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UIToolbar.self]).tintColor = .white
    }

    // swiftlint:disable closure_body_length
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                TextField(Localizable.loginTextfieldEmailHint(), text: $email)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(UIColor.lightGray), lineWidth: 1)
                    )
                    .keyboardType(.emailAddress)
                    .accentColor(.black)
                SecureField(Localizable.loginTextfieldPasswordHint(), text: $password)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(UIColor.lightGray), lineWidth: 1)
                    )
                    .accentColor(.black)
                Button(
                    action: {
                        // TODO: Implement in integrate task
                    }, label: {
                        Text(Localizable.actionLogin())
                            .frame(width: 100, height: 50)
                    }
                )
                .background(Color.green)
                .cornerRadius(8)
                Button(
                    action: {
                        // TODO: Implement in integrate task
                    }, label: {
                        Text(Localizable.loginNeedaccountTitle())
                            .frame(height: 25)
                    }
                )
                .foregroundColor(.green)
            }
            .padding()
            .navigationTitle(Localizable.loginTitle())
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(backgroundColor: .green)
            .toolbar { navigationBarLeadingContent }
        }.accentColor(.white)

    }

    var navigationBarLeadingContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(
                action: {
                    // TODO: Implement in integrate task
                },
                label: {
                    Image(systemName: "xmark")
                }
            )
        }
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LoginViewModel()

        return LoginView(viewModel: viewModel)
    }
}
#endif
