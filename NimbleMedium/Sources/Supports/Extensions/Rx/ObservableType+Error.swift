//
//  ObservableType+Error.swift
//  NimbleMedium
//
//  Created by Minh Pham on 26/08/2021.
//

import Foundation

import RxSwift
import RxCocoa

extension ObservableType {

    func asDriverOrEmptyIfError() -> Driver<Element> {
        asDriver { _ in .empty() }
    }
}
