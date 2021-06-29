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
            let decoder = JSONDecoderContainer(container: containter, key: .string($0.value.key))
            try $0.value.decode(from: decoder)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        let containter = encoder.container(keyedBy: JSONCodingKey.self)
        try children().forEach {
            let encoder = JSONEncoderContainer(key: .string($0.value.key), container: containter)
            try $0.value.encode(to: encoder)
        }
    }
}


extension JSONModel {
    /// JSON 转模型
    public init(from JSON: Any,
                options: JSONSerialization.WritingOptions = .prettyPrinted) throws {
        let data = try JSONSerialization.data(withJSONObject: JSON, options: options)
        try self.init(from: data)
    }
    
    /// JSON 字符串转模型
    public init(from JSONString: String,
                 encoding: String.Encoding = .utf8,
                 allowLossyConversion: Bool = false) throws {
        guard let data = JSONString.data(using: encoding, allowLossyConversion: allowLossyConversion) else {
            throw CocoaError.error(.coderInvalidValue)
        }
        try self.init(from: data)
    }
    
    /// Data 转模型
    public init(from data: Data) throws {
        self = try Self.decoder.decode(Self.self, from: data)
    }
    
    /// 模型转 JSON
    public func asJSON(options: JSONSerialization.ReadingOptions = .mutableContainers) throws -> Any {
        try JSONSerialization.jsonObject(with: try asData(), options: options)
    }
    
    /// 模型转 JSON字符串
    public func asJSONString(encoding: String.Encoding = .utf8) throws -> String? {
        String(data: try asData(), encoding: encoding)
    }
    
    /// 模型转 Data
    public func asData() throws -> Data {
        try Self.encoder.encode(self)
    }
}



// MARK: - JSONDecoderContainer
public struct JSONDecoderContainer: Decoder, SingleValueDecodingContainer {

    
    let container: KeyedDecodingContainer<JSONCodingKey>
    let key: JSONCodingKey
    
    public var codingPath: [CodingKey] {
        container.codingPath
    }
    
    public var userInfo: [CodingUserInfoKey: Any] { [:] }
    
    // container
    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        try container.nestedContainer(keyedBy: Key.self, forKey: key)
    }
    
    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        try container.nestedUnkeyedContainer(forKey: key)
    }
    
    public func singleValueContainer() throws -> SingleValueDecodingContainer { self }
    
    // decode
    public func decode(_ type: Bool.Type) throws -> Bool {
        if let value = try? container.decode(Int.self, forKey: key) {
            return value != 0
        }
        if let value = try? container.decode(String.self, forKey: key) {
            if value == "true" || value == "false" || value == "True" || value == "False" {
                return value == "true" || value == "True"
            }
        }
        return try container.decode(Bool.self, forKey: key)
    }

    public func decode(_ type: String.Type) throws -> String {
        if let value = try? container.decode(Int.self, forKey: key) {
            return value.description
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value.description
        }
        return try container.decode(String.self, forKey: key)
    }

    public func decode(_ type: Double.Type) throws -> Double {
        if let value = try? container.decode(String.self, forKey: key),
           let doubleValue = Double(value) {
            return doubleValue
        }
        if let value = try? container.decode(Int.self, forKey: key) {
            return Double(value)
        }
        return try container.decode(Double.self, forKey: key)
    }

    public func decode(_ type: Float.Type) throws -> Float {
        if let value = try? container.decode(String.self, forKey: key),
           let doubleValue = Float(value) {
            return doubleValue
        }
        if let value = try? container.decode(Int.self, forKey: key) {
            return Float(value)
        }
        return try container.decode(Float.self, forKey: key)
    }

    public func decode(_ type: Int.Type) throws -> Int {
        if let value = try? container.decode(String.self, forKey: key),
           let intValue = Int(value) {
            return intValue
        }
        return try container.decode(Int.self, forKey: key)
    }

    public func decode(_ type: Int8.Type) throws -> Int8 {
        if let value = try? container.decode(String.self, forKey: key),
           let intValue = Int8(value) {
            return intValue
        }
        return try container.decode(Int8.self, forKey: key)
    }

    public func decode(_ type: Int16.Type) throws -> Int16 {
        if let value = try? container.decode(String.self, forKey: key),
           let intValue = Int16(value) {
            return intValue
        }
        return try container.decode(Int16.self, forKey: key)
    }

    public func decode(_ type: Int32.Type) throws -> Int32 {
        if let value = try? container.decode(String.self, forKey: key),
           let intValue = Int32(value) {
            return intValue
        }
        return try container.decode(Int32.self, forKey: key)
    }

    public func decode(_ type: Int64.Type) throws -> Int64 {
        if let value = try? container.decode(String.self, forKey: key),
           let intValue = Int64(value) {
            return intValue
        }
        return try container.decode(Int64.self, forKey: key)
    }

    public func decode(_ type: UInt.Type) throws -> UInt {
        if let value = try? container.decode(String.self, forKey: key),
           let intValue = UInt(value) {
            return intValue
        }
        return try container.decode(UInt.self, forKey: key)
    }

    public func decode(_ type: UInt8.Type) throws -> UInt8 {
        if let value = try? container.decode(String.self, forKey: key),
           let intValue = UInt8(value) {
            return intValue
        }
        return try container.decode(UInt8.self, forKey: key)
    }

    public func decode(_ type: UInt16.Type) throws -> UInt16 {
        if let value = try? container.decode(String.self, forKey: key),
           let intValue = UInt16(value) {
            return intValue
        }
        return try container.decode(UInt16.self, forKey: key)
    }

    public func decode(_ type: UInt32.Type) throws -> UInt32 {
        if let value = try? container.decode(String.self, forKey: key),
           let intValue = UInt32(value) {
            return intValue
        }
        return try container.decode(UInt32.self, forKey: key)
    }

    public func decode(_ type: UInt64.Type) throws -> UInt64 {
        if let value = try? container.decode(String.self, forKey: key),
           let intValue = UInt64(value) {
            return intValue
        }
        return try container.decode(UInt64.self, forKey: key)
    }
    
    public func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        let value: Any?
        switch type {
            case is Bool.Type: fallthrough
            case is Optional<Bool>.Type: value = try? decode(Bool.self)
                
            case is String.Type: fallthrough
            case is Optional<String>.Type: value = try? decode(String.self)
                
            case is Double.Type: fallthrough
            case is Optional<Double>.Type: value = try? decode(Double.self)
                
            case is Float.Type: fallthrough
            case is Optional<Float>.Type: value = try? decode(Float.self)
                
            case is Int.Type: fallthrough
            case is Optional<Int>.Type: value = try? decode(Int.self)
                
            case is Int8.Type: fallthrough
            case is Optional<Int8>.Type: value = try? decode(Int8.self)
                
            case is Int16.Type: fallthrough
            case is Optional<Int16>.Type: value = try? decode(Int16.self)
                
            case is Int32.Type: fallthrough
            case is Optional<Int32>.Type: value = try? decode(Int32.self)
                
            case is Int64.Type: fallthrough
            case is Optional<Int64>.Type: value = try? decode(Int64.self)
                
            case is UInt.Type: fallthrough
            case is Optional<UInt>.Type: value = try? decode(UInt.self)
                
            case is UInt8.Type: fallthrough
            case is Optional<UInt8>.Type: value = try? decode(UInt8.self)
                
            case is UInt16.Type: fallthrough
            case is Optional<UInt16>.Type: value = try? decode(UInt16.self)
                
            case is UInt32.Type: fallthrough
            case is Optional<UInt32>.Type: value = try? decode(UInt32.self)
                
            case is UInt64.Type: fallthrough
            case is Optional<UInt64>.Type: value = try? decode(UInt64.self)
            default: value = nil
        }
        
        if let value = value {
            return value as! T
        }
        return try container.decode(T.self, forKey: key)
    }
    
    public func decodeNil() -> Bool {
        do {
            return try self.container.decodeNil(forKey: key)
        } catch {
            return true
        }
    }
}


// MARK: - JSONEncoderContainer
public class JSONEncoderContainer: Encoder, SingleValueEncodingContainer {
    private var container: KeyedEncodingContainer<JSONCodingKey>
    let key: JSONCodingKey
    
    init(key: JSONCodingKey, container: KeyedEncodingContainer<JSONCodingKey>) {
        self.key = key
        self.container = container
    }
    
    public var codingPath: [CodingKey] {
        container.codingPath
    }
    
    public var userInfo: [CodingUserInfoKey : Any] {
        [:]
    }
    
    // container
    public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        return container.nestedContainer(keyedBy: Key.self, forKey: key)
    }
    
    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        return container.nestedUnkeyedContainer(forKey: key)
    }
    
    public func singleValueContainer() -> SingleValueEncodingContainer { self }
    
    // encode
    public func encode<T>(_ value: T) throws where T : Encodable {
        try container.encode(value, forKey: key)
    }
    
    public func encodeNil() throws {
        try container.encodeNil(forKey: key)
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
