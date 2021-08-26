//
//  RxErrorTracker.swift
//  NimbleMedium
//
//  Created by Minh Pham on 26/08/2021.
//

import Foundation
import RxSwift
import RxCocoa

final class RxErrorTracker: SharedSequenceConvertibleType {

    typealias SharingStrategy = DriverSharingStrategy

    private let subject = PublishSubject<Error>()

    func asObservable() -> Observable<Error> {
        subject.asObservable()
    }

    func asSharedSequence() -> SharedSequence<DriverSharingStrategy, Error> {
        subject.asDriverOrEmptyIfError()
    }

    fileprivate func track<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        source.asObservable().do(onError: onError)
    }

    private func onError(_ error: Error) {
        subject.onNext(error)
    }

    deinit {
        subject.onCompleted()
    }
}

// MARK: - ObservableConvertibleType

extension ObservableConvertibleType {

    func trackError(_ tracker: RxErrorTracker) -> Observable<Element> {
        tracker.track(from: self)
    }
}
