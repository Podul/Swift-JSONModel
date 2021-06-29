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

struct AnyValue {
    let value: Any
}

protocol FieldCodable {
    var key: String { get }
    var value: Any { get }
    
    func decode(from decoder: Decoder) throws
    func encode(to encoder: Encoder) throws
}


// MARK: - Base
@propertyWrapper
open class BaseFiled<Wrapper>: FieldCodable where Wrapper: Codable {
    
    let key: String
    var value: Any { anyValue!.value }
    var anyValue: AnyValue?
    
    public init(_ key: String) {
        self.key = key
    }
    
    public var wrappedValue: Wrapper {
        get { value as! Wrapper }
        set { anyValue = AnyValue(value: newValue) }
    }
    
    func decode(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let valueType = Wrapper.self as? OptionalType.Type {
            if container.decodeNil() {
                wrappedValue = (valueType.nil as! Wrapper)
                return
            }
        }
        wrappedValue = try container.decode(Wrapper.self)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

extension BaseFiled: CustomStringConvertible {
    public var description: String {
        if let value = value as? CustomStringConvertible {
            return value.description
        }
        return "\(value)"
    }
}


// MARK: - _Optional
public protocol OptionalType {
    static var `nil`: Any { get }
}

extension Optional: OptionalType {
    public static var `nil`: Any { Optional.none as Any }
}
