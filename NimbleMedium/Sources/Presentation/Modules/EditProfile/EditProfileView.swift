//
//  EditProfileView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 12/10/2021.
//

import SwiftUI
import ToastUI
import Resolver

struct EditProfileView: View {

    @Environment(\.presentationMode) var presentationMode

    @State private var avatarURL = ""
    @State private var username = ""
    @State private var bio = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationView {
            contentView
                .onTapGesture { hideKeyboard() }
                .navigationBarTitle(Localizable.editProfileTitleText(), displayMode: .inline)
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

    var contentView: some View {
        ScrollView {
            VStack(spacing: 15.0) {
                AppTextFieldView(
                    placeholder: Localizable.editProfileTextFieldAvatarURLPlaceholder(),
                    text: $avatarURL)
                AppTextFieldView(
                    placeholder: Localizable.editProfileTextFieldUsernamePlaceholder(),
                    text: $username)
                AppTextView(
                    placeholder: Localizable.editProfileTextViewBioPlaceholder(),
                    text: $bio)
                    .frame(height: 200.0, alignment: .leading)
                AppTextFieldView(
                    placeholder: Localizable.editProfileTextFieldEmailPlaceholder(),
                    text: $email)
                AppSecureFieldView(
                    placeholder: Localizable.editProfileTextFieldPasswordPlaceholder(),
                    text: $password)
                AppMainButton(title: Localizable.actionUpdateText()) {
                    // TODO: Handle update my profile profile details in integrate task, dismiss view for now
                    presentationMode.wrappedValue.dismiss()
                }
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
