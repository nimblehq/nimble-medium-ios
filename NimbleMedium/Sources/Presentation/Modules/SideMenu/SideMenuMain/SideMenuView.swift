//
//  SideMenuView.swift
//  NimbleMedium
//
//  Created by Mark G on 11/08/2021.
//

import Resolver
import SwiftUI

struct SideMenuView: View {

    @ObservedViewModel private var viewModel: SideMenuViewModelProtocol = Resolver.resolve()

    @Injected private var sideMenuActionsViewModel: SideMenuActionsViewModelProtocol
    @Injected private var sideMenuHeaderViewModel: SideMenuHeaderViewModelProtocol

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
        viewModel.input.bindData(
            sideMenuActionsViewModel: sideMenuActionsViewModel,
            sideMenuHeaderViewModel: sideMenuHeaderViewModel
        )
    }
}

#if DEBUG
    struct SideMenuView_Previews: PreviewProvider {
        static var previews: some View { SideMenuView() }
    }
#endif
