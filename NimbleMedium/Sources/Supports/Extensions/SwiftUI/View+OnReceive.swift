//
//  View+RxDriver.swift
//  NimbleMedium
//
//  Created by Mark G on 16/08/2021.
//

import RxCocoa
import RxCombine
import RxSwift
import SwiftUI

extension View {

    @inlinable
    func onReceive<Element>(
        _ driver: Driver<Element>,
        perform action: @escaping (Element) -> Void
    ) -> some View {
        onReceive(driver.asObservable(), perform: action)
    }

    @inlinable
    func onReceive<Element>(
        _ signal: Signal<Element>,
        perform action: @escaping (Element) -> Void
    ) -> some View {
        onReceive(signal.asObservable(), perform: action)
    }

    @inlinable
    func onReceive<Element>(
        _ observable: Observable<Element>,
        perform action: @escaping (Element) -> Void
    ) -> some View {
        onReceive(observable.publisher.assertNoFailure(), perform: action)
    }
}
