//
//  SideMenuHeaderView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 23/08/2021.
//

import SwiftUI
import SDWebImageSwiftUI
import Resolver

struct SideMenuHeaderView: View {

    @ObservedViewModel private var viewModel: SideMenuHeaderViewModelProtocol = Resolver.resolve()

    @State private var isAuthenticated = false
    @State private var avatarUrl: String?
    @State private var username = Localizable.menuHeaderUsernameDefault()

    var body: some View {
        ZStack(alignment: .center) {
            Color.green.edgesIgnoringSafeArea(.all)
            if isAuthenticated {
                authenticatedMenuHeader
            } else {
                unauthenticatedMenuHeader
            }
        }
        .onReceive(viewModel.output.uiModel) { bindData(uiModel: $0) }
    }

    var authenticatedMenuHeader: some View {
        VStack(alignment: .center) {
            if let url = try? avatarUrl?.asURL() {
                WebImage(url: url)
                    .placeholder { defaultAvatar }
                    .resizable()
                    .frame(width: 100.0, height: 100.0)
                    .clipShape(Circle())
            } else {
                defaultAvatar
            }
            Text(username)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .padding()
        }
    }

    var unauthenticatedMenuHeader: some View {
        VStack(alignment: .center) {
            Text(Localizable.menuHeaderTitle())
                .foregroundColor(.white)
                .font(.system(size: 28, weight: .heavy, design: .default))
                .padding()
            Text(Localizable.menuHeaderDescription())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
        }
    }

    var defaultAvatar: some View {
        Image(R.image.defaultAvatar.name)
            .resizable()
            .frame(width: 100.0, height: 100.0)
            .clipShape(Circle())
    }
}

private extension SideMenuHeaderView {
    
    func bindData(uiModel: UIModel?) {
        if let user = uiModel {
            isAuthenticated = true
            avatarUrl = user.avatarUrl
            username = user.username
        } else {
            isAuthenticated = false
            avatarUrl = nil
            username = Localizable.menuHeaderUsernameDefault()
        }
    }
}

#if DEBUG
struct SideMenuHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuHeaderView()
    }
}
#endif
