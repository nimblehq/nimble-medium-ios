//
//  UserProfileView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 23/09/2021.
//

import PagerTabStripView
import Resolver
import SDWebImageSwiftUI
import SwiftUI
import ToastUI

struct UserProfileView: View {

    @ObservedViewModel var viewModel: UserProfileViewModelProtocol

    @State private var uiModel: UIModel?
    @State private var errorMessage = ""
    @State private var errorToast = false
    @State private var selectedTabIndex: Int = 0
    @State private var createdArticlesViewModel: UserProfileCreatedArticlesTabViewModelProtocol?
    @State private var favoritedArticlesViewModel: UserProfileFavoritedArticlesTabViewModelProtocol?

    private let username: String?
    private var isCurrentUserProfile: Bool { username == nil }

    var body: some View {
        VStack {
            profileHeader
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 30.0)
                .background(Color.gray)

            PagerTabStripView(selection: $selectedTabIndex) {
                if let viewModel = createdArticlesViewModel {
                    UserProfileCreatedArticlesTab(viewModel: viewModel)
                }

                if let viewModel = favoritedArticlesViewModel {
                    UserProfileFavoritedArticlesTab(viewModel: viewModel)
                }
            }
            .pagerTabStripViewStyle(
                .normal(
                    indicatorBarColor: .green,
                    tabItemHeight: 50.0,
                    placedInToolbar: false
                )
            )
        }
        .navigationTitle(
            isCurrentUserProfile ? Localizable.userProfileCurrentTitle() : Localizable.userProfileOtherTitle()
        )
        .modifier(NavigationBarPrimaryStyle())
        .onAppear { viewModel.input.getUserProfile() }
        .toast(isPresented: $errorToast, dismissAfter: 3.0) {
            ToastView(errorMessage) {} background: {
                Color.clear
            }
        }
        .bind(viewModel.output.createdArticlesViewModel, to: _createdArticlesViewModel)
        .bind(viewModel.output.favoritedArticlesViewModel, to: _favoritedArticlesViewModel)
        .bind(viewModel.output.userProfileUIModel, to: _uiModel)
        .onReceive(viewModel.output.errorMessage) { _ in
            errorMessage = Localizable.errorGenericMessage()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { errorToast.toggle() }
        }
    }

    var profileHeader: some View {
        VStack(alignment: .center, spacing: 0.0) {
            AvatarView(url: uiModel?.avatarURL)
                .size(120.0)
                .circle()
            Text(uiModel?.username ?? Localizable.userProfileUsernameUnknown())
                .foregroundColor(.white)
                .fontWeight(.bold)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .padding()
            HStack {
                Spacer()

                if !isCurrentUserProfile {
                    FollowButton(isSelected: uiModel?.isFollowing ?? false, style: .dark) {
                        viewModel.input.toggleFollowUser()
                    }
                }
            }
            .padding(.horizontal, 20.0)
        }
    }

    init(username: String? = nil) {
        self.username = username

        viewModel = Resolver.resolve(
            UserProfileViewModelProtocol.self,
            args: username
        )
    }
}

#if DEBUG
    struct UserProfileView_Previews: PreviewProvider {
        static var previews: some View { UserProfileView() }
    }
#endif
