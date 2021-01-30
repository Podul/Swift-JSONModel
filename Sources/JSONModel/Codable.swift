//
//  I am not responsible of this code.
//
//	File.swift
//  
//	
//	Created by Podul on 2021/1/30
//	Copyright © 2021 Podul. All rights reserved.
//


import Foundation


extension JSONModel {
    public init(from decoder: Decoder) throws {
        self.init()
        let containter = try decoder.container(keyedBy: JSONCodingKey.self)
        try children().forEach {
            let decoder = JSONSingleDecoderContainer(container: containter, key: .string($0.value.key))
            try $0.value.decode(from: decoder)
        }
    }

    public func encode(to encoder: Encoder) throws {
        let containter = encoder.container(keyedBy: JSONCodingKey.self)
        try children().forEach {
            let encoder = JSONSingleEncoderContainer(container: containter, key: .string($0.value.key))
            try $0.value.encode(to: encoder)
        }
    }
}


extension JSONModel {
    /// JSON 转模型
    public init(from JSON: Any,
                decoder: JSONDecoder = .init(),
                options: JSONSerialization.WritingOptions = .prettyPrinted) throws {
        let data = try JSONSerialization.data(withJSONObject: JSON, options: options)
        try self.init(from: data, decoder: decoder)
    }
    
    /// JSON 字符串转模型
    public init?(from JSONString: String,
                 encoding: String.Encoding = .utf8,
                 allowLossyConversion: Bool = false) throws {
        guard let data = JSONString.data(using: encoding, allowLossyConversion: allowLossyConversion) else {
            return nil
        }
        try self.init(from: data)
    }
    
    /// Data 转模型
    public init(from data: Data, decoder: JSONDecoder = .init()) throws {
        self = try decoder.decode(Self.self, from: data)
    }
    
    /// 模型转 JSON
    public func asJSON(encoder: JSONEncoder = .init(),
                       options: JSONSerialization.ReadingOptions = .mutableContainers) throws -> Any {
        try JSONSerialization.jsonObject(with: try asData(), options: options)
    }
    
    /// 模型转 JSON字符串
    public func asJSONString(encoding: String.Encoding = .utf8) throws -> String? {
        String(data: try asData(), encoding: encoding)
    }
    
    /// 模型转 Data
    public func asData(encoder: JSONEncoder = .init()) throws -> Data {
        try encoder.encode(self)
    }
}



// MARK: - ContainerEncoder
public struct JSONSingleDecoderContainer: Decoder, SingleValueDecodingContainer {
    let container: KeyedDecodingContainer<JSONCodingKey>
    let key: JSONCodingKey
    
    public var codingPath: [CodingKey] {
        self.container.codingPath
    }
    
    public var userInfo: [CodingUserInfoKey : Any] { [:] }
    
    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        try self.container.nestedContainer(keyedBy: Key.self, forKey: self.key)
    }
    
    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        try self.container.nestedUnkeyedContainer(forKey: self.key)
    }
    
    public func singleValueContainer() throws -> SingleValueDecodingContainer { self }
    
    public func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        try self.container.decode(T.self, forKey: self.key)
    }
    
    public func decodeNil() -> Bool {
        do {
            return try self.container.decodeNil(forKey: self.key)
        } catch {
            return true
        }
    }
}


// MARK: - ContainerEncoder
public struct JSONSingleEncoderContainer: Encoder, SingleValueEncodingContainer {
    
    var container: KeyedEncodingContainer<JSONCodingKey>
    let key: JSONCodingKey
    
    public var codingPath: [CodingKey] {
        self.container.codingPath
    }
    
    public var userInfo: [CodingUserInfoKey : Any] {
        [:]
    }
    
    public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        var container = self.container
        return container.nestedContainer(keyedBy: Key.self, forKey: self.key)
    }
    
    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        var container = self.container
        return container.nestedUnkeyedContainer(forKey: self.key)
    }
    
    public func singleValueContainer() -> SingleValueEncodingContainer { self }
    
    mutating public func encode<T>(_ value: T) throws where T : Encodable {
        try self.container.encode(value, forKey: self.key)
    }
    
    mutating public func encodeNil() throws {
        try self.container.encodeNil(forKey: self.key)
    }
}

// MARK: - _ModelCodingKey
public enum JSONCodingKey: CodingKey {
    case string(String)
    case int(Int)
    
    public var stringValue: String {
        switch self {
        case .int(let int): return int.description
        case .string(let string): return string
        }
    }
    
    public var intValue: Int? {
        switch self {
        case .int(let int): return int
        case .string(let string): return Int(string)
        }
    }
    
    public init?(stringValue: String) {
        self = .string(stringValue)
    }
    
    public init?(intValue: Int) {
        self = .int(intValue)
    }
}




// MARK - try other type
extension SingleValueDecodingContainer {
    public func tryInt() -> Int? {
        tryDecodable(Int.self)
    }
    
    public func tryString() -> String? {
        tryDecodable(String.self)
    }
    
    public func tryBool() -> Bool? {
        tryDecodable(Bool.self)
    }
    
    public func tryDouble() -> Double? {
        tryDecodable(Double.self)
    }
    
    public func tryFloat() -> Float? {
        tryDecodable(Float.self)
    }
    
    public func tryDecodable<D>(_ type: D.Type = D.self) -> D? where D: Decodable {
        if let value = try? decode(D.self) {
            return value
        }
        return try? decode(Optional<D>.self)
    }
}
