//
//  SideMenuHeaderView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 23/08/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct SideMenuHeaderView: View {

    // TODO: Update this observable to correct value in integrate task
    @State private var isAuthenticated = true

    var body: some View {
        ZStack(alignment: .center) {
            Color.green.edgesIgnoringSafeArea(.all)

            if isAuthenticated {
                authenticatedMenuHeader
            } else {
                unauthenticatedMenuHeader
            }
        }
    }

    var authenticatedMenuHeader: some View {
        VStack(alignment: .center) {
            // TODO: Update this avatar url to correct value in integrate task
            // swiftlint:disable line_length
            if let url = try? "https://thumbs.dreamstime.com/b/vector-illustration-avatar-dummy-logo-collection-image-icon-stock-isolated-object-set-symbol-web-137160339.jpg".asURL() {
                // FIXME: It blocks UI
                WebImage(url: url)
                    .placeholder { defaultAvatar }
                    .resizable()
                    .frame(width: 100.0, height: 100.0)
                    .clipShape(Circle())
            } else {
                defaultAvatar
            }
            // TODO: Update this username to correct value in integrate task
            Text(Localizable.menuHeaderUsernameDefault())
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

#if DEBUG
struct SideMenuHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuHeaderView()
    }
}
#endif
