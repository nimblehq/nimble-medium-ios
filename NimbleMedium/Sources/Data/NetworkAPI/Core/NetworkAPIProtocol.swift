//
//  NetworkAPIProtocol.swift
//  NimbleMedium
//
//  Created by Minh Pham on 26/08/2021.
//

import Alamofire
import RxAlamofire
import RxSwift

protocol NetworkAPIProtocol {

    func performRequest<T: Decodable>(_ configuration: RequestConfiguration, for type: T.Type) -> Single<T>
}

extension NetworkAPIProtocol {

    func request<T: Decodable>(
        session: Session,
        configuration: RequestConfiguration,
        decoder: JSONDecoder
    ) -> Single<T> {
        return session.rx.request(
            configuration.method,
            configuration.url,
            parameters: configuration.parameters,
            encoding: configuration.encoding,
            headers: configuration.headers,
            interceptor: configuration.interceptor
        )
        .responseData()
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .validate()
        .flatMap { data -> Single<T> in
            do {
                let decodable = try decoder.decode(T.self, from: data)
                return .just(decodable)
            } catch {
                return .error(error)
            }
        }
        .observe(on: MainScheduler.instance)
        .asSingle()
    }

    func request(
        session: Session,
        configuration: RequestConfiguration,
        decoder: JSONDecoder
    ) -> Completable {
        return session.rx.request(
            configuration.method,
            configuration.url,
            parameters: configuration.parameters,
            encoding: configuration.encoding,
            headers: configuration.headers,
            interceptor: configuration.interceptor
        )
        .responseData()
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .validate()
        .flatMap { _ -> Completable in .empty() }
        .observe(on: MainScheduler.instance)
        .asCompletable()
    }
}

// MARK: - Private

extension ObservableType where Element == (HTTPURLResponse, Data) {

    fileprivate func validate() -> Observable<Data> {
        map { _, data -> Data in
            // Handle addition data check here if needed
            data
        }
    }
}
