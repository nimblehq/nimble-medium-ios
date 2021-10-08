//
//  AuthenticatedNetworkAPIProtocol.swift
//  NimbleMedium
//
//  Created by Minh Pham on 29/09/2021.
//

import Foundation

/*
 We need this protocol due to Resolver doesn't support dependency injection
 for multiple instances of the same protocol
 */
protocol AuthenticatedNetworkAPIProtocol: NetworkAPIProtocol {}
