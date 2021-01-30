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

public protocol JSONModel: Codable {
    init()
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
