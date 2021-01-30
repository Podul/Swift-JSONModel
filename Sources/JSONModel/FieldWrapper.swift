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
        if let valueType = Wrapper.self as? _Optional.Type {
            if container.decodeNil() {
                self.wrappedValue = (valueType._none as! Wrapper)
                return
            }
        }
        
        if let value = try? tryDecode(from: decoder) {
            self.wrappedValue = value
            return
        }
        
        self.wrappedValue = try container.decode(Wrapper.self)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.wrappedValue)
    }
    
    
    open func tryDecode(from decoder: Decoder) throws -> Wrapper? {
        let container = try decoder.singleValueContainer()

        switch Wrapper.self {
            case is String?.Type: fallthrough
            case is String.Type:
                if let value = container.tryString() {
                    return value as? Wrapper
                }
                if let value = container.tryInt() {
                    return value.description as? Wrapper
                }
                if let value = container.tryDouble() {
                    return value.description as? Wrapper
                }
            case is Int?.Type: fallthrough
            case is Int.Type:
                if let value = container.tryInt() {
                    return value as? Wrapper
                }
                if let value = container.tryBool() {
                    return (value ? 1 : 0) as? Wrapper
                }
                if let value = container.tryString(), let int = Int(value) {
                    return int as? Wrapper
                }
            case is Bool?.Type: fallthrough
            case is Bool.Type:
                if let value = container.tryBool() {
                    return value as? Wrapper
                }
                if let value = container.tryInt() {
                    if value == 0 { return false as? Wrapper }
                    if value == 1 { return true as? Wrapper }
                }
                if let value = container.tryString() {
                    if value == "0" || value == "False" || value == "false" || value == "NO" {
                        return false as? Wrapper
                    }
                    if value == "1" || value == "True" || value == "true" || value == "YES" {
                        return true as? Wrapper
                    }
                }
            default: break
        }
        
        return nil
    }
}


// MARK: - _Optional
private protocol _Optional {
    static var _none: Any { get }
}

extension Optional: _Optional {
    static var _none: Any { Optional.none as Any }
}
