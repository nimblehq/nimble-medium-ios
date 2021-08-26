//
//  SideMenuView.swift
//  NimbleMedium
//
//  Created by Mark G on 11/08/2021.
//

import SwiftUI

struct SideMenuView: View {

    @ObservedViewModel private var viewModel: SideMenuViewModelProtocol

    var body: some View {
        GeometryReader { metrics in
            VStack(alignment: .center) {
                SideMenuHeaderView()
                    .frame(height: metrics.size.height * 0.3)
                SideMenuActionsView(viewModel: viewModel.output.sideMenuActionsViewModel)
            }
        }
    }

    init(viewModel: SideMenuViewModelProtocol) {
        self.viewModel = viewModel
    }
}

#if DEBUG
struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        let factory = DependencyFactory(networkAPI: NetworkAPI())
        let viewModel = SideMenuViewModel(factory: factory)
        return SideMenuView(viewModel: viewModel)
    }
}
#endif
