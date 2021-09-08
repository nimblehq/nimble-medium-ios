//
//  Decodable.swift
//
//  Copyright © 2021 Leandro Nunes Fantinatto. All rights reserved.
//  Ref: https://github.com/gonzalezreal/DefaultCodable
//  Ref: https://github.com/JohnSundell/Codextended
//

import Foundation

/// Generic property-wrapper to provide default values for non-optional properties when they are not present or have a nil value.
/// Use-case examples:
/// - @DecodableDefault.EmptyString var title: String
/// - @DecodableDefault.False var isFeaturedEnabled: Bool
/// - @DecodableDefault.True var isFeatureEnabled: Bool
/// - @DecodableDefault.EmptyList var data: [SomeModel]
/// - @DecodableDefault.EmptyMap var dict: [String : Any]
///

protocol DecodableDefaultSource {

    associatedtype Value: Decodable

    static var defaultValue: Value { get }
}

enum DecodableDefault {}

extension DecodableDefault {

    typealias Source = DecodableDefaultSource
    typealias List = Decodable & ExpressibleByArrayLiteral
    typealias Map = Decodable & ExpressibleByDictionaryLiteral

    // Convenience aliases to reference the provided `enum Sources` as specialized versions of our property wrapper type.
    typealias True = Wrapper<Sources.True>
    typealias False = Wrapper<Sources.False>
    typealias EmptyString = Wrapper<Sources.EmptyString>
    typealias EmptyList<T: List> = Wrapper<Sources.EmptyList<T>>
    typealias EmptyMap<T: Map> = Wrapper<Sources.EmptyMap<T>>
    typealias Zero = Wrapper<Sources.Zero>
    typealias One = Wrapper<Sources.One>

    @propertyWrapper
    struct Wrapper<Source: DecodableDefaultSource> {
        typealias Value = Source.Value

        var wrappedValue = Source.defaultValue
    }
    
    enum Sources {
        enum True: Source {
            static var defaultValue: Bool { true }
        }
        enum False: Source {
            static var defaultValue: Bool { false }
        }

        enum EmptyString: Source {
            static var defaultValue: String { "" }
        }
        enum EmptyList<T: List>: Source {
            static var defaultValue: T { [] }
        }
        enum EmptyMap<T: Map>: Source {
            static var defaultValue: T { [:] }
        }

        enum Zero: Source {
            static var defaultValue: Int { 0 }
        }
        enum One: Source {
            static var defaultValue: Int { 1 }
        }
    }
}

extension DecodableDefault.Wrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(Value.self)
    }
}

extension DecodableDefault.Wrapper: Equatable where Value: Equatable {}
extension DecodableDefault.Wrapper: Hashable where Value: Hashable {}
extension DecodableDefault.Wrapper: Encodable where Value: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

extension KeyedDecodingContainer {
    func decode<T>(_ type: DecodableDefault.Wrapper<T>.Type, forKey key: Key) throws -> DecodableDefault.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}
