//
//  CreateArticleView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 13/10/2021.
//

import SwiftUI

struct CreateArticleView: View {

    @Environment(\.presentationMode) var presentationMode

    @State private var title = ""
    @State private var description = ""
    @State private var articleBody = ""
    @State private var tagsList = ""

    var body: some View {
        NavigationView {
            contentView
                .onTapGesture { hideKeyboard() }
                .navigationBarTitle(Localizable.createArticleTitleText(), displayMode: .inline)
                .navigationBarColor(backgroundColor: .green)
                .toolbar { navigationBarLeadingContent }
        }
        .accentColor(.white)
    }

    var navigationBarLeadingContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(
                action: { presentationMode.wrappedValue.dismiss() },
                label: { Image(systemName: SystemImageName.xmark.rawValue) }
            )
        }
    }

    var contentView: some View {
        ScrollView {
            VStack(spacing: 15.0) {
                AppTextField(
                    placeholder: Localizable.createArticleTextFieldTitlePlaceholder(),
                    text: $title)
                    .font(.system(size: 20))
                AppTextField(
                    placeholder: Localizable.createArticleTextFieldDescriptionPlaceholder(),
                    text: $description)
                AppTextView(
                    placeholder: Localizable.createArticleTextViewBodyPlaceholder(),
                    text: $articleBody)
                    .frame(height: 200.0, alignment: .leading)
                AppTextField(
                    placeholder: Localizable.createArticleTextFieldTagsListPlaceholder(),
                    text: $tagsList)
                AppMainButton(title: Localizable.actionPublishText()) {
                    // TODO: Handle update my profile profile details in integrate task, dismiss view for now
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding()
        }
    }
}

#if DEBUG
struct CreateArticleView_Previews: PreviewProvider {
    static var previews: some View { CreateArticleView() }
}
#endif
