//
//  RequestConfiguration.swift
//  NimbleMedium
//
//  Created by Minh Pham on 26/08/2021.
//

import Foundation
import Alamofire

protocol RequestConfiguration {

    var baseURL: String { get }

    var endpoint: String { get }

    var method: HTTPMethod { get }

    var url: URLConvertible { get }

    var parameters: Parameters? { get }

    var encoding: ParameterEncoding { get }

    var headers: HTTPHeaders? { get }

    var interceptor: RequestInterceptor? { get }
}

extension RequestConfiguration {

    var url: URLConvertible {
        let url = URL(string: baseURL)?.appendingPathComponent(endpoint)
        return url?.absoluteString ?? "\(baseURL)\(endpoint)"
    }

    var parameters: Parameters? {
        nil
    }

    var headers: HTTPHeaders? {
        HTTPHeaders([
            HTTPHeader.contentType("application/json; charset=utf-8")
        ])
    }

    var interceptor: RequestInterceptor? {
        nil
    }
}
