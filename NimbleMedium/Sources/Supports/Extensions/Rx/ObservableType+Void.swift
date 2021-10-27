//
//  ObservableType+Void.swift
//  NimbleMedium
//
//  Created by Minh Pham on 01/10/2021.
//

import RxCocoa
import RxSwift

extension ObservableType {

    func mapToVoid() -> Observable<Void> {
        map { _ in }
    }
}

extension SharedSequenceConvertibleType {

    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        map { _ in }
    }
}

extension PrimitiveSequenceType where Trait == SingleTrait {

    func mapToVoid() -> PrimitiveSequence<Trait, Void> {
        map { _ in }
    }
}
