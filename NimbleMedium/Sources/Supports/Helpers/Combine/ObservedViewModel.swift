//
//  ObservedViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 25/08/2021.
//

import SwiftUI
import Combine

@propertyWrapper
struct ObservedViewModel<ViewModel>: DynamicProperty {

    var wrappedValue: ViewModel

    @ObservedObject private var observableObject: AnyObservableObject

    init(wrappedValue: ViewModel) {
        self.wrappedValue = wrappedValue

        if let objectWillChange = (wrappedValue as? ObservableViewModel)?.objectWillChange {
            observableObject = .init(objectWillChange: objectWillChange.eraseToAnyPublisher())
        } else {
            observableObject = .init(objectWillChange: Empty().eraseToAnyPublisher())
        }
    }

    mutating func update() {
        _observableObject.update()
    }
}

extension ObservedViewModel {

    private class AnyObservableObject: ObservableObject {

        let objectWillChange: AnyPublisher<Void, Never>

        init(objectWillChange: AnyPublisher<Void, Never>) {
            self.objectWillChange = objectWillChange
        }
    }
}
