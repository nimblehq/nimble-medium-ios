//
//  NetworkAPI.swift
//  NimbleMedium
//
//  Created by Minh Pham on 26/08/2021.
//

import Alamofire
import Foundation
import RxSwift

final class NetworkAPI: NetworkAPIProtocol {

    private let decoder: JSONDecoder
    private let session: Session

    init(decoder: JSONDecoder = .default) {
        self.decoder = decoder
        session = Session(interceptor: CommonInterceptor())
    }

    func performRequest<T: Decodable>(_ configuration: RequestConfiguration, for type: T.Type) -> Single<T> {
        request(
            session: session,
            configuration: configuration,
            decoder: decoder
        )
    }
}

// MARK: - Error

extension Error {

    var detail: String { localizedDescription }
}
