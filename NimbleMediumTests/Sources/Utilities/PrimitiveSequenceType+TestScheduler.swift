//
//  PrimitiveSequenceType+TestScheduler.swift
//  NimbleMediumTests
//
//  Created by Mark G on 20/09/2021.
//

import RxSwift
import RxTest

extension PrimitiveSequenceType {

    static func just(_ element: Element, on scheduler: TestScheduler, at time: TestTime) -> Single<Element> {
        .create { observer in
            scheduler.scheduleAt(time) { observer(.success(element)) }
            return Disposables.create()
        }
    }

    static func error(_ error: Error, on scheduler: TestScheduler, at time: TestTime) -> Single<Element> {
        .create { observer in
            scheduler.scheduleAt(time) { observer(.failure(error)) }
            return Disposables.create()
        }
    }
}
