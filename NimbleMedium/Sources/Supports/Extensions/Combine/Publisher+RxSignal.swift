//  swiftlint:disable:this file_name
//
//  Publisher+RxSignal.swift
//  NimbleMedium
//
//  Created by Mark G on 30/08/2021.
//

import Combine
import RxCombine
import RxCocoa

extension Published.Publisher {

    func asSignal() -> Signal<Value> {
        self.asObservable()
            .skip(1)
            .asSignal(onErrorSignalWith: .empty())
    }
}
