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

    @ObservedViewModel private var viewModel: EditArticleViewModelProtocol = Resolver.resolve()

    @State private var title = ""
    @State private var description = ""
    @State private var articleBody = ""
    @State private var tagsList = ""
    @State private var isFetchArticleDetailFailed = false
    @State private var isFetchArticleDetailSuccess = false
    @State private var isLoadingToastPresented = false
    @State private var isErrorToastPresented = false

    var body: some View {
        NavigationView {
            contentView
                .onTapGesture { hideKeyboard() }
                .navigationBarTitle(Localizable.editArticleTitleText(), displayMode: .inline)
                .navigationBarColor(backgroundColor: .green)
                .toolbar { navigationBarLeadingContent }
        }
        .accentColor(.white)
        .toast(isPresented: $isErrorToastPresented, dismissAfter: 3.0) {
            ToastView(Localizable.errorGeneric()) {} background: {
                Color.clear
            }
        }
        .onAppear { viewModel.input.fetchArticleDetail() }
        .onReceive(viewModel.output.didFailToUpdateArticle) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isErrorToastPresented = true
            }
        }
        .onReceive(viewModel.output.didUpdateArticle) { _ in presentationMode.wrappedValue.dismiss() }
        .onReceive(viewModel.output.didFailToFetchArticleDetail) { _ in
            isErrorToastPresented = true
            isFetchArticleDetailFailed = true
        }
        .bind(viewModel.output.isLoading, to: _isLoadingToastPresented)
        .onReceive(viewModel.output.uiModel) {
            guard let uiModel = $0 else { return }
            isFetchArticleDetailSuccess = true
            title = uiModel.title
            description = uiModel.description
            articleBody = uiModel.articleBody
            tagsList = uiModel.tagsList
        }
        .toast(isPresented: $isLoadingToastPresented) {
            ToastView(String.empty) {}
                .toastViewStyle(IndefiniteProgressToastViewStyle())
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

    var contentView: some View {
        Group {
            if isFetchArticleDetailSuccess { form } else {
                if isFetchArticleDetailFailed {
                    Text(Localizable.articleDetailFetchFailureMessage())
                } else { ProgressView() }
            }
        }
    }

    // swiftlint:disable closure_body_length
    var form: some View {
        ScrollView {
            VStack(spacing: 15.0) {
                LabeledAppTextField(
                    title: Localizable.editArticleTextFieldTitleTitle(),
                    placeholder: Localizable.editArticleTextFieldTitlePlaceholder(),
                    text: $title
                ).font(.system(size: 20))
                LabeledAppTextField(
                    title: Localizable.editArticleTextFieldDescriptionTitle(),
                    placeholder: Localizable.editArticleTextFieldDescriptionPlaceholder(),
                    text: $description
                )
                LabeledAppTextView(
                    title: Localizable.editArticleTextViewBodyTitle(),
                    placeholder: Localizable.editArticleTextViewBodyPlaceholder(),
                    text: $articleBody
                ).frame(height: 230.0, alignment: .leading)
                LabeledAppTextField(
                    title: Localizable.editArticleTextFieldTagsListTitle(),
                    placeholder: Localizable.editArticleTextFieldTagsListPlaceholder(),
                    text: $tagsList
                )
                AppMainButton(title: Localizable.actionUpdateText()) {
                    viewModel.input.didTapUpdateButton(
                        title: title,
                        description: description,
                        body: articleBody,
                        tagsList: tagsList
                    )
                }.disabled(title.isEmpty && description.isEmpty && articleBody.isEmpty && tagsList.isEmpty)
            }.padding()
        }
    }
}

#if DEBUG
    struct EditArticleView_Previews: PreviewProvider {
        static var previews: some View { EditArticleView() }
    }
#endif
