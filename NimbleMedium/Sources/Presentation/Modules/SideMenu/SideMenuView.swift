//
//  SideMenuView.swift
//  NimbleMedium
//
//  Created by Mark G on 11/08/2021.
//

import SwiftUI

struct SideMenuView: View {

    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.black.opacity(0.7))

            HStack {
                GeometryReader { geo in
                    Text("This is side menu") // TODO: Update it in Integrate task
                        .frame(width: geo.size.width * 2 / 3, height: geo.size.height)
                        .background(Color.white)
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView()
    }
}
