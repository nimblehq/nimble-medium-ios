//
//  SideMenuView.swift
//  NimbleMedium
//
//  Created by Mark G on 11/08/2021.
//

import SwiftUI

struct SideMenuView: View {

    private var factory: ViewModelFactoryProtocol

    var body: some View {
        GeometryReader { metrics in
            VStack(alignment: .center) {
                SideMenuHeaderView().frame(height: metrics.size.height * 0.3)
                SideMenuActionsView(factory: factory)
            }
        }
    }

    init(factory: ViewModelFactoryProtocol) {
        self.factory = factory
    }
}

#if DEBUG
struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(factory: DependencyFactory())
    }
}
#endif
