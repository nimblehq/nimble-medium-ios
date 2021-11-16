//
//  CreateArticleView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 13/10/2021.
//

import Resolver
import SwiftUI
import ToastUI

struct CreateArticleView: View {

    @ObservedViewModel private var viewModel: CreateArticleViewModelProtocol = Resolver.resolve()

    @Environment(\.presentationMode) var presentationMode

    @State private var title = ""
    @State private var description = ""
    @State private var articleBody = ""
    @State private var tagsList = ""

    @State private var errorMessage = ""
    @State private var errorToast = false
    @State private var loadingToast = false
    @State private var firstTimeLoad = true

    var body: some View {
        NavigationView {
            contentView
                .onTapGesture { hideKeyboard() }
                .navigationBarTitle(Localizable.createArticleTitleText(), displayMode: .inline)
                .navigationBarColor(backgroundColor: .green)
                .toolbar { navigationBarLeadingContent }
                .toast(isPresented: $errorToast, dismissAfter: 3.0) {
                    ToastView(errorMessage) {} background: {
                        Color.clear
                    }
                }
                .toast(isPresented: $loadingToast) {
                    ToastView(String.empty) {}
                        .toastViewStyle(IndefiniteProgressToastViewStyle())
                }
        }
        .accentColor(.white)
        .bind(viewModel.output.isLoading, to: _loadingToast)
        .onReceive(viewModel.output.didCreateArticle) { _ in presentationMode.wrappedValue.dismiss() }
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
                LabeledAppTextField(
                    title: Localizable.createArticleTextFieldTitleTitle(),
                    placeholder: Localizable.createArticleTextFieldTitlePlaceholder(),
                    text: $title
                ).font(.system(size: 20))
                LabeledAppTextField(
                    title: Localizable.createArticleTextFieldDescriptionTitle(),
                    placeholder: Localizable.createArticleTextFieldDescriptionPlaceholder(),
                    text: $description
                )
                LabeledAppTextView(
                    title: Localizable.createArticleTextViewBodyTitle(),
                    placeholder: Localizable.createArticleTextViewBodyPlaceholder(),
                    text: $articleBody
                ).frame(height: 230.0, alignment: .leading)
                LabeledAppTextField(
                    title: Localizable.createArticleTextFieldTagsListTitle(),
                    placeholder: Localizable.createArticleTextFieldTagsListPlaceholder(),
                    text: $tagsList
                )
                AppMainButton(title: Localizable.actionPublishText()) {
                    hideKeyboard()
                    viewModel.input.didTapPublishButton(
                        title: title, description: description, body: articleBody, tagsList: tagsList
                    )
                }.disabled(title.isEmpty && description.isEmpty && articleBody.isEmpty && tagsList.isEmpty)
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
