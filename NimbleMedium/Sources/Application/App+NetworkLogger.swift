//
//  App+NetworkLogger.swift
//  NimbleMedium
//
//  Created by Mark G on 23/08/2021.
//

import AlamofireNetworkActivityLogger

extension App {

    func configureNetworkLogger() {
        #if DEBUG
        // Print alamofire request & response log
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
        #endif
    }
}
