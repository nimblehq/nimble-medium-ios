//
//  BehaviorRelayProperty.swift
//  MVVMRxSwiftDemo
//
//  Created by Nguyen M. Tam on 15/06/2021.
//

import RxCocoa
import RxSwift

@propertyWrapper
struct BehaviorRelayProperty<Element, Wrapped> {

    private let disposeBag = DisposeBag()

    let projectedValue: BehaviorRelay<Element>
    let wrappedValue: Wrapped
    
    init(_ value: Element, transform: (BehaviorRelay<Element>) -> Wrapped) {
        projectedValue = BehaviorRelay(value: value)
        wrappedValue = transform(projectedValue)
    }
}

// MARK: - Observable

extension BehaviorRelayProperty where Wrapped == Observable<Element> {

    init(_ value: Element) {
        projectedValue = BehaviorRelay(value: value)
        wrappedValue = projectedValue.asObservable()
    }
}

// MARK: - Driver

extension BehaviorRelayProperty where Wrapped == Driver<Element> {

    init(_ value: Element) {
        projectedValue = BehaviorRelay(value: value)
        wrappedValue = projectedValue.asDriver()
    }
}
