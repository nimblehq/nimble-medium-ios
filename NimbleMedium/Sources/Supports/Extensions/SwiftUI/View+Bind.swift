//
//  View+Bind.swift
//  NimbleMedium
//
//  Created by Mark G on 10/09/2021.
//

import SwiftUI
import RxCocoa
import RxCombine

extension View {

    func bind<Element>(_ driver: Driver<Element>, to state: State<Element>) -> some View {
        onReceive(driver) { value in
            state.wrappedValue = value
        }
    }
}
