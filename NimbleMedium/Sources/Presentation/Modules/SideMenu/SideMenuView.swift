//
//  SideMenuView.swift
//  NimbleMedium
//
//  Created by Mark G on 11/08/2021.
//

import SwiftUI

struct SideMenuView: View {

    private var isOpen: Bool {
        viewModel.isOpen
    }

    @ObservedObject var viewModel: SideMenuViewModel
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.black.opacity(0.7))
            .opacity(isOpen ? 1.0 : 0.0)
            .animation(.easeIn(duration: 0.5))
            .onTapGesture {
                viewModel.toggle(false)
            }

            HStack {
                GeometryReader { geo in
                    // TODO: Implement Side Menu content UI
                    Text("This is side menu content")
                        .frame(width: geo.size.width * 2 / 3, height: geo.size.height)
                        .background(Color.white)
                        .offset(x: isOpen ? 0 : -geo.size.width * 2 / 3)
                        .animation(.easeIn(duration: 0.5))
                }
            }
        }
        .ignoresSafeArea()
    }
}

#if DEBUG
struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(viewModel: SideMenuViewModel())
    }
}
#endif
