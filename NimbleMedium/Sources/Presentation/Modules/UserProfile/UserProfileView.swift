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

struct UserProfileView: View {

    @State private var uiModel: UIModel?

    @ObservedViewModel var viewModel: UserProfileViewModelProtocol

    private let username: String?

    var body: some View {
        ScrollView(.vertical) {
            profileHeader
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 30.0)
                .background(Color.gray)

            // TODO: Implement Articles section in another feature task
            Text("Articles section")
                .padding(.horizontal, 8.0)
        }
        .navigationTitle(Localizable.userProfileTitle())
        .modifier(NavigationBarPrimaryStyle())
        .onAppear { viewModel.input.getUserProfile() }
        .bind(viewModel.output.userProfileUIModel, to: _uiModel)
    }

    var profileHeader: some View {
        VStack(alignment: .center, spacing: 0.0) {
            if let url = uiModel?.avatarURL {
                WebImage(url: url)
                    .placeholder { defaultAvatar }
                    .resizable()
                    .frame(width: 120.0, height: 120.0)
                    .clipShape(Circle())
            } else {
                defaultAvatar
            }
            Text(uiModel?.username ?? Localizable.defaultUsernameValue())
                .foregroundColor(.white)
                .fontWeight(.bold)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .padding()
        }
    }

    var defaultAvatar: some View {
        Image(R.image.defaultAvatar.name)
            .resizable()
            .frame(width: 120.0, height: 120.0)
            .clipShape(Circle())
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
