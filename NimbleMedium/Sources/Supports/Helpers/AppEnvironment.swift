//
//  AppEnvironment.swift
//  NimbleMedium
//
//  Created by Mark G on 20/08/2021.
//

import Foundation

enum AppEnvironment {

    static func based<T>(staging: T, production: T) -> T {
        #if PRODUCTION
        return production
        #else
        return staging
        #endif
    }
}
