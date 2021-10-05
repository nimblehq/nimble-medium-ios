//
//  SideMenuView.swift
//  NimbleMedium
//
//  Created by Mark G on 11/08/2021.
//

import SwiftUI
import Resolver

struct SideMenuView: View {

    @ObservedViewModel private var viewModel: SideMenuViewModelProtocol = Resolver.resolve()

    @Injected private var sideMenuActionsViewModel: SideMenuActionsViewModelProtocol

    var body: some View {
        GeometryReader { metrics in
            VStack(alignment: .center) {
                SideMenuHeaderView()
                    .frame(height: metrics.size.height * 0.3)
                SideMenuActionsView()
            }
        }
    }

    init() {
        viewModel.input.bindData(sideMenuActionsViewModel: sideMenuActionsViewModel)
    }
}

#if DEBUG
struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View { SideMenuView() }
}
#endif
