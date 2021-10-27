//
//  View+Bind.swift
//  NimbleMedium
//
//  Created by Mark G on 10/09/2021.
//

import RxCocoa
import RxCombine
import SwiftUI

extension View {

    func bind<Element>(_ driver: Driver<Element>, to state: State<Element>) -> some View {
        onReceive(driver) { value in
            state.wrappedValue = value
        }
    }

    func bind<Element>(_ signal: Signal<Element>, to state: State<Element>) -> some View {
        onReceive(signal) { value in
            state.wrappedValue = value
        }
    }
}
