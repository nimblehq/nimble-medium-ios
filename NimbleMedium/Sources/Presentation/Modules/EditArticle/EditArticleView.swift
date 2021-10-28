//
//  EditArticleView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 28/10/2021.
//

import Resolver
import SwiftUI
import ToastUI

struct EditArticleView: View {

    @Environment(\.presentationMode) var presentationMode

    @State private var title = ""
    @State private var description = ""
    @State private var articleBody = ""
    @State private var tagsList = ""

    private let slug: String

    var body: some View {
        NavigationView {
            contentView
                .onTapGesture { hideKeyboard() }
                .navigationBarTitle(Localizable.editArticleTitleText(), displayMode: .inline)
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
                    placeholder: Localizable.editArticleTextFieldTitlePlaceholder(),
                    text: $title
                )
                .font(.system(size: 20))
                AppTextField(
                    placeholder: Localizable.editArticleTextFieldDescriptionPlaceholder(),
                    text: $description
                )
                AppTextView(
                    placeholder: Localizable.editArticleTextViewBodyPlaceholder(),
                    text: $articleBody
                )
                .frame(height: 200.0, alignment: .leading)
                AppTextField(
                    placeholder: Localizable.editArticleTextFieldTagsListPlaceholder(),
                    text: $tagsList
                )
                AppMainButton(title: Localizable.actionUpdateText()) {
                    // TODO: Implement in integrate task
                }
            }
            .padding()
        }
    }

    init(slug: String) {
        self.slug = slug
    }
}

#if DEBUG
    struct EditArticleView_Previews: PreviewProvider {
        static var previews: some View { EditArticleView(slug: "") }
    }
#endif
