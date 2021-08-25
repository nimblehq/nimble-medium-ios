//
//  SideMenuHeaderView.swift
//  NimbleMedium
//
//  Created by Minh Pham on 23/08/2021.
//

import SwiftUI

struct SideMenuHeaderView: View {

    var body: some View {
        ZStack(alignment: .center) {
            Color.green.edgesIgnoringSafeArea(.all)
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
    }
}

#if DEBUG
struct SideMenuHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuHeaderView()
    }
}
#endif
