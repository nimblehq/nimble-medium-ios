//
//  Completable+TestScheduler.swift
//  NimbleMediumTests
//
//  Created by Mark G on 14/10/2021.
//

import RxSwift
import RxTest

extension Completable {

    static func empty(on scheduler: TestScheduler, at time: TestTime) -> Completable {
        .create { observer in
            scheduler.scheduleAt(time) { observer(.completed) }
            return Disposables.create()
        }
    }

    static func error(_ error: Error, on scheduler: TestScheduler, at time: TestTime) -> Completable {
        .create { observer in
            scheduler.scheduleAt(time) { observer(.error(error)) }
            return Disposables.create()
        }
    }
}
