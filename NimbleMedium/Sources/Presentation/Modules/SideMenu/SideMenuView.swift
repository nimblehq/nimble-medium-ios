//
//  SideMenuView.swift
//  NimbleMedium
//
//  Created by Mark G on 11/08/2021.
//

import SwiftUI

struct SideMenuView: View {
    
    var body: some View {
        VStack(alignment: .center) {
            // TODO: Implement Menu Header UI
            SideMenuActionsView()
        }
    }
}

#if DEBUG
struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView()
    }
}
#endif
