//
//  I am not responsible of this code.
//
//	Model.swift
//  
//	
//	Created by Podul on 2021/1/30
//	Copyright © 2021 Podul. All rights reserved.
//


import Foundation

public protocol JSONModel: Codable, CustomStringConvertible {
    init()
    
    static var decoder: JSONDecoder { get }
    static var encoder: JSONEncoder { get }
}

extension JSONModel {
    public static var decoder: JSONDecoder { .init() }
    public static var encoder: JSONEncoder { .init() }
}

extension JSONModel {
    public var description: String {
        children().reduce(into: [String: Any](), {
            if let value = $1.value.value as? OptionalType {
                $0[$1.value.key] = value
            }else {
                $0[$1.value.key] = $1.value.value
            }
        })
        .description
    }
}


// MARK: - Private
private var _instances = [ObjectIdentifier: Any]()
extension JSONModel {
    static var instance: Self {
        if let value = _instances[ObjectIdentifier(self)] as? Self {
            return value
        }
        let value = self.init()
        _instances[ObjectIdentifier(self)] = value
        return value
    }
    
    func children() -> [(label: String, value: FieldCodable)] {
        let mirror = Mirror(reflecting: self)
        var arr = mirror.children.compactMap { field -> (String, FieldCodable)? in
            guard let label = field.label else { return nil }
            guard let value = field.value as? FieldCodable else { return nil }
            return (label, value)
        }
        
        // 添加父类
        var superclassMirror = mirror.superclassMirror
        while true {
            guard let childMirror = superclassMirror else { break }
            arr += childMirror.children.compactMap { field -> (String, FieldCodable)? in
                guard let label = field.label else { return nil }
                guard let value = field.value as? FieldCodable else { return nil }
                return (label, value)
            }
            superclassMirror = childMirror.superclassMirror
        }
        return arr
    }
}
