//
//  Expectation+TestableObserver.swift
//  NimbleMediumTests
//
//  Created by Mark G on 20/09/2021.
//

import Nimble
import RxNimble
import RxSwift
import RxTest

extension Expectation where T: ObserverType {

    func events() -> Expectation<RecordedEvents<T.Element>> {

        transform { _ in
            guard let testObserver = (try? self.expression.evaluate()) as? TestableObserver<T.Element> else {
                return []
            }

            return testObserver.events
        }
    }
}

extension Expectation {
    #if swift(>=4.1)
    #else
        fileprivate init(_ expression: Expression<T>) {
            self.expression = expression
        }
    #endif

    private func transform<U>(_ closure: @escaping (T?) throws -> U?) -> Expectation<U> {
        let exp = expression.cast(closure)
        #if swift(>=4.1)
            return Expectation<U>(expression: exp)
        #else
            return Expectation<U>(exp)
        #endif
    }
}
