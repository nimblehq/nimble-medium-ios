//
//  SideMenuView.swift
//  NimbleMedium
//
//  Created by Mark G on 11/08/2021.
//

import SwiftUI

struct SideMenuView: View {

    private var factory: ViewModelFactoryProtocol
    private var onSelectOptionItem: (() -> Void)?

    var body: some View {
        GeometryReader { metrics in
            VStack(alignment: .center) {
                SideMenuHeaderView().frame(height: metrics.size.height * 0.3)
                SideMenuActionsView(factory: factory) { onSelectOptionItem?() }
            }
        }
    }

    init(factory: ViewModelFactoryProtocol, onSelectOptionItem: (() -> Void)? = nil) {
        self.factory = factory
        self.onSelectOptionItem = onSelectOptionItem
    }
}

#if DEBUG
struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(factory: DependencyFactory())
    }
}
#endif
