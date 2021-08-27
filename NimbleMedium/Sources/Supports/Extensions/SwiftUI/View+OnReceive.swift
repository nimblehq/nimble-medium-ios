//
//  View+RxDriver.swift
//  NimbleMedium
//
//  Created by Mark G on 16/08/2021.
//

import SwiftUI
import RxCocoa
import RxCombine

extension View {

    @inlinable
    func onReceive<Element>(
        _ signal: Signal<Element>,
        perform action: @escaping (Element) -> Void
    ) -> some View {
        onReceive(signal.publisher.assertNoFailure(), perform: action)
    }
}
