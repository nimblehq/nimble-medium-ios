//
//  RxActivityIndicator.swift
//  NimbleMedium
//
//  Created by Minh Pham on 26/08/2021.
//

import RxSwift
import RxCocoa

final class RxActivityIndicator: SharedSequenceConvertibleType {

    typealias SharingStrategy = DriverSharingStrategy

    private let lock = NSRecursiveLock()
    private let relay = BehaviorRelay(value: 0)
    private let loading: SharedSequence<SharingStrategy, Bool>

    init() {
        loading = relay.asDriver().map { $0 > 0 }.distinctUntilChanged()
    }

    func asObservable() -> Observable<Bool> {
        loading.asObservable()
    }

    func asSharedSequence() -> SharedSequence<SharingStrategy, Bool> {
        loading
    }

    fileprivate func track<O: ObservableConvertibleType>(_ source: O) -> Observable<O.Element> {
        Observable.using { [weak self] () -> DisposableIndicator<O.Element> in
            self?.show()
            return DisposableIndicator(source: source.asObservable(), disposeAction: self?.dismiss ?? {})
        } observableFactory: { disposable in
            disposable.asObservable()
        }
    }

    private func show() {
        lock.lock()
        relay.accept(relay.value + 1)
        lock.unlock()
    }

    private func dismiss() {
        lock.lock()
        relay.accept(relay.value - 1)
        lock.unlock()
    }
}

// MARK: - DisposableIndicator

extension RxActivityIndicator {

    private struct DisposableIndicator<E>: ObservableConvertibleType, Disposable {

        private let source: Observable<E>
        private let disposable: Cancelable

        init(source: Observable<E>, disposeAction: @escaping () -> Void) {
            self.source = source
            disposable = Disposables.create(with: disposeAction)
        }

        func dispose() {
            disposable.dispose()
        }

        func asObservable() -> Observable<E> {
            source
        }
    }
}

// MARK: - ObservableConvertibleType

extension ObservableConvertibleType {

    func trackIndicator(_ indicator: RxActivityIndicator) -> Observable<Element> {
        indicator.track(self)
    }
}
