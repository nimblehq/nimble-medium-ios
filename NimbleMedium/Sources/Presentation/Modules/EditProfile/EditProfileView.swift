//
//  EditProfileView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 12/10/2021.
//

import Resolver
import SwiftUI
import ToastUI

struct EditProfileView: View {

    @ObservedViewModel private var viewModel: EditProfileViewModelProtocol = Resolver.resolve()

    @Environment(\.presentationMode) var presentationMode

    @State private var uiModel = UIModel()
    @State private var password = ""

    @State private var errorMessage = ""
    @State private var errorToast = false
    @State private var loadingToast = false

    var body: some View {
        NavigationView {
            contentView
                .onTapGesture { hideKeyboard() }
                .navigationBarTitle(Localizable.editProfileTitleText(), displayMode: .inline)
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
        .onAppear { viewModel.input.getCurrentUserProfile() }
        .bind(viewModel.output.isLoading, to: _loadingToast)
        .bind(viewModel.output.editProfileUIModel, to: _uiModel)
        .onReceive(viewModel.output.didUpdateProfile) { _ in presentationMode.wrappedValue.dismiss() }
        .onReceive(viewModel.output.errorMessage) { _ in
            errorMessage = Localizable.errorGeneric()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { errorToast.toggle() }
        }

    }

    var navigationBarLeadingContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(
                action: { presentationMode.wrappedValue.dismiss() },
                label: { Image(systemName: SystemImageName.xmark.rawValue) }
            )
        }
    }

    // swiftlint:disable closure_body_length
    var contentView: some View {
        ScrollView {
            VStack(spacing: 15.0) {
                AppTextField(
                    placeholder: Localizable.editProfileTextFieldAvatarURLPlaceholder(),
                    text: $uiModel.avatarURL)
                AppTextField(
                    placeholder: Localizable.editProfileTextFieldUsernamePlaceholder(),
                    text: $uiModel.username)
                AppTextView(
                    placeholder: Localizable.editProfileTextViewBioPlaceholder(),
                    text: $uiModel.bio)
                    .frame(height: 200.0, alignment: .leading)
                AppTextField(
                    placeholder: Localizable.editProfileTextFieldEmailPlaceholder(),
                    text: $uiModel.email)
                AppSecureField(
                    placeholder: Localizable.editProfileTextFieldPasswordPlaceholder(),
                    text: $password)
                AppMainButton(title: Localizable.actionUpdateText()) {
                    hideKeyboard()
                    viewModel.input.didTapUpdateButton(
                        username: uiModel.username,
                        email: uiModel.email,
                        password: password,
                        avatarURL: uiModel.avatarURL,
                        bio: uiModel.bio
                    )
                }
                .disabled(uiModel.allFieldsAreEmpty && password.isEmpty)
            }
            .padding()
        }
    }
}

#if DEBUG
struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View { EditProfileView() }
}
#endif
