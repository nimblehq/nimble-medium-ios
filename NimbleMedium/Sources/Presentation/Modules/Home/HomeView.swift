//
//  HomeView.swift
//  NimbleMedium
//
//  Created by Mark G on 06/08/2021.
//

import SwiftUI
import RxSwift
import RxCocoa
import RxCombine

struct HomeView: View {
    static let sideMenuCoordinateSpaceName = "SideMenu"

    @ObservedViewModel private var viewModel: HomeViewModelProtocol
    @State private var displaySideMenuProgress: CGFloat = 0.0
    private let draggingAnimator = SideMenuDraggingAnimator()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                FeedsView(viewModel: viewModel.output.feedsViewModel)
                sideMenuDimmedBackground
                GeometryReader { geo in
                    SideMenuView(viewModel: viewModel.output.sideMenuViewModel)
                        .frame(width: geo.size.width * 2.0 / 3.0, height: geo.size.height)
                        .background(Color.white)
                        .offset(x: (1 - displaySideMenuProgress) * -geo.size.width * 2 / 3)
                        .coordinateSpace(name: Self.sideMenuCoordinateSpaceName)
                }
            }
            .ignoresSafeArea()
            .onReceive(viewModel.output.isSideMenuOpenDidChange) { isOpen in
                withAnimation {
                    self.displaySideMenuProgress = isOpen ? 1.0 : 0.0
                }

                self.draggingAnimator.reset(isOpen: isOpen)
            }
            .gesture(
                DragGesture(coordinateSpace: .named(Self.sideMenuCoordinateSpaceName))
                    .onChanged { gesture in
                        // FIXME: It should return current size of SideMenu
                        let width = geo.frame(in: .named(Self.sideMenuCoordinateSpaceName)).width * 2 / 3

                        draggingAnimator.onDraggingChanged(gesture, width) {
                            displaySideMenuProgress = $1
                        }
                    }
                    .onEnded { _ in
                        draggingAnimator.onDraggingEnded { isOpen, _ in
                            self.viewModel.input.toggleSideMenu(isOpen)
                        }
                    }
            )
        }
    }

    var sideMenuDimmedBackground: some View {
        GeometryReader { _ in
            EmptyView()
        }
        .background(Color.black.opacity(0.7))
        .opacity(Double(displaySideMenuProgress) * 0.75)
        .onTapGesture {
            viewModel.input.toggleSideMenu(false)
        }
    }

    init (viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let factory = DependencyFactory(networkAPI: NetworkAPI())
        let viewModel = HomeViewModel(factory: factory)
        return HomeView(viewModel: viewModel)
    }
}
#endif
