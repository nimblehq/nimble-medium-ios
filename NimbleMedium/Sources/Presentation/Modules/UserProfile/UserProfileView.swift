//
//  UserProfileView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 23/09/2021.
//

import Resolver
import SDWebImageSwiftUI
import SwiftUI
import ToastUI
import PagerTabStripView

struct UserProfileView: View {

    @State private var uiModel: UIModel?
    @State private var errorMessage = ""
    @State private var errorToast = false

    @ObservedViewModel var viewModel: UserProfileViewModelProtocol

    private let username: String?
    
    @State private var selectedTabIndex: Int = 0

    var body: some View {
        VStack {
            profileHeader
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 30.0)
                .background(Color.gray)

            PagerTabStripView(selection: $selectedTabIndex) {
                // TODO: Add Created Articles List
                Text("")
                    .pagerTabItem { TabItemTitle("Empty Tab") }
                ArticleList()
                    .pagerTabItem {
                        TabItemTitle(Localizable.userProfileFavouritedArticlesTitle())
                    }
            }
            .pagerTabStripViewStyle(
                .barButton(
                    indicatorBarHeight: 2.0,
                    indicatorBarColor: .green,
                    tabItemSpacing: 0.0,
                    tabItemHeight: 50.0,
                    placedInToolbar: false
                )
            )
        }
        .navigationTitle(username != nil ? Localizable.userProfileOtherTitle() : Localizable.userProfileCurrentTitle())
        .modifier(NavigationBarPrimaryStyle())
        .onAppear { viewModel.input.getUserProfile() }
        .toast(isPresented: $errorToast, dismissAfter: 3.0) {
            ToastView(errorMessage) { } background: {
                Color.clear
            }
        }
        .bind(viewModel.output.userProfileUIModel, to: _uiModel)
        .onReceive(viewModel.output.errorMessage) { _ in
            errorMessage = Localizable.errorGeneric()
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
        }
    }
}

private extension UserProfileView {

    class NavTabViewTheme: ObservableObject {
        @Published var textColor = Color.gray
    }

    struct TabItemTitle: View, PagerTabViewDelegate {

        let title: String

        @ObservedObject fileprivate var theme = NavTabViewTheme()

        var body: some View {
            VStack {
                Spacer()
                Text(title)
                    .foregroundColor(theme.textColor)
                    .font(.subheadline)
                Spacer()
                Divider()
                    .frame(height: 1)
                    .background(Color(R.color.lightGray.name))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }

        init(_ title: String) {
            self.title = title
        }

        func setState(state: PagerTabViewState) {
            switch state {
            case .selected:
                theme.textColor = .green
            default:
                theme.textColor = .gray
            }
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
