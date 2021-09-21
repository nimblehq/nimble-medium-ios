//
//  HomeView.swift
//  NimbleMedium
//
//  Created by Mark G on 06/08/2021.
//

import Resolver
import RxCocoa
import RxCombine
import RxSwift
import SwiftUI

struct HomeView: View {

    @ObservedViewModel private var viewModel: HomeViewModelProtocol = Resolver.resolve()

    @State private var displaySideMenuProgress: CGFloat = 0.0

    private let draggingAnimator = SideMenuDraggingAnimator()
    private let sideMenuCoordinateSpaceName = "SideMenu"

    var body: some View {
        GeometryReader { geo in
            ZStack {
                FeedsView()
                sideMenuDimmedBackground
                GeometryReader { geo in
                    SideMenuView()
                        .frame(width: geo.size.width * 2.0 / 3.0, height: geo.size.height)
                        .background(Color.white)
                        .offset(x: (1 - displaySideMenuProgress) * -geo.size.width * 2.0 / 3.0)
                        .coordinateSpace(name: sideMenuCoordinateSpaceName)
                }
            }
            .ignoresSafeArea()
            .onReceive(viewModel.output.isSideMenuOpenDidChange) { isOpen in
                withAnimation {
                    displaySideMenuProgress = isOpen ? 1.0 : 0.0
                }

                draggingAnimator.reset(isOpen: isOpen)
            }
            // TODO: Fix conflict with scrolling in FeedsView
            .gesture(dragGesture(geo: geo))
        }
    }

    private var sideMenuDimmedBackground: some View {
        GeometryReader { _ in
            EmptyView()
        }
        .background(Color.black.opacity(0.7))
        .opacity(Double(displaySideMenuProgress) * 0.75)
        .onTapGesture {
            viewModel.input.toggleSideMenu(false)
        }
    }

    private func dragGesture(geo: GeometryProxy) -> some Gesture {
        DragGesture(coordinateSpace: .named(sideMenuCoordinateSpaceName))
            .onChanged { gesture in
                // FIXME: It should return current size of SideMenu
                let width = geo.frame(in: .named(sideMenuCoordinateSpaceName)).width * 2.0 / 3.0

                draggingAnimator.onDraggingChanged(gesture, width) {
                    displaySideMenuProgress = $1
                }
            }
            .onEnded { _ in
                draggingAnimator.onDraggingEnded { isOpen, _ in
                    viewModel.input.toggleSideMenu(isOpen)
                }
            }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View { HomeView() }
}
#endif
