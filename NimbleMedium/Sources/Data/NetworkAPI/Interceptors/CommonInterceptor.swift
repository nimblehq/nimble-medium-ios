//
//  CommonInterceptor.swift
//  NimbleMedium
//
//  Created by Mark G on 15/11/2021.
//

import Alamofire
import Foundation

final class CommonInterceptor: RequestInterceptor {

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        request.headers.add(name: "X-Requested-With", value: "XMLHttpRequest")
        completion(.success(request))
    }
}
