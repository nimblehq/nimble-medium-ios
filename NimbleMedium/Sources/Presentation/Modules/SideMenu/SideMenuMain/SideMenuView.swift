//
//  SideMenuView.swift
//  NimbleMedium
//
//  Created by Mark G on 11/08/2021.
//

import SwiftUI

struct SideMenuView: View {

    private var viewModel: SideMenuViewModelProtocol

    @State private var sideMenuActionsViewModel: SideMenuActionsViewModelProtocol?

    var body: some View {
        GeometryReader { metrics in
            VStack(alignment: .center) {
                SideMenuHeaderView().frame(height: metrics.size.height * 0.3)
                if let sideMenuActionsViewModel = sideMenuActionsViewModel {
                    SideMenuActionsView(viewModel: sideMenuActionsViewModel)
                }
            }
        }
        .onReceive(viewModel.output.sideMenuActionsViewModel) {
            sideMenuActionsViewModel = $0
        }
    }

    init(viewModel: SideMenuViewModelProtocol) {
        self.viewModel = viewModel
    }
}

#if DEBUG
struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(viewModel: SideMenuViewModel(factory: DependencyFactory()))
    }
}
#endif
