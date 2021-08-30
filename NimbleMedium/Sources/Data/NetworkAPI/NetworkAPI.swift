//
//  NetworkAPI.swift
//  NimbleMedium
//
//  Created by Minh Pham on 26/08/2021.
//

import Foundation
import Alamofire
import RxSwift

final class NetworkAPI: NetworkAPIProtocol {

    private let decoder: JSONDecoder
    private let session: Session

    init(decoder: JSONDecoder = JSONDecoder.default) {
        self.decoder = decoder
        session = Session()
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
