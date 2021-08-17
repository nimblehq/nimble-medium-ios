//
//  PublishRelayProperty.swift
//  NimbleMedium
//
//  Created by Mark G on 16/08/2021.
//

import RxCocoa
import RxSwift

@propertyWrapper
struct PublishRelayProperty<WrappedElement> {

    let projectedValue: PublishRelay<WrappedElement>
    let wrappedValue: Observable<WrappedElement>

    init() {
        projectedValue = PublishRelay()
        wrappedValue = projectedValue.asObservable()
    }
}
