//
//  ObservableViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 25/08/2021.
//

import Combine

protocol ObservableViewModel: AnyObject {

    var objectWillChange: ObservableObjectPublisher { get }
}
