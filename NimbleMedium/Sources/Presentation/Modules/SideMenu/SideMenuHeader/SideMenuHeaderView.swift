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

    @Injected private var homeViewModel: HomeViewModelProtocol

    @State private var uiModel: UIModel?

    var body: some View {
        ZStack(alignment: .center) {
            Color.green.edgesIgnoringSafeArea(.all)
            if let uiModel = uiModel {
                authenticatedMenuHeader(uiModel: uiModel)
            } else {
                unauthenticatedMenuHeader
            }
        }
        .bind(viewModel.output.uiModel, to: _uiModel)
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

    init() {
        viewModel.input.bindData(homeViewModel: homeViewModel)
    }

    func authenticatedMenuHeader(uiModel: UIModel) -> some View {
        VStack(alignment: .center) {
            AvatarView(url: uiModel.avatarURL)
                .size(100.0)
                .circle()
            Text(uiModel.username)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .padding()
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
