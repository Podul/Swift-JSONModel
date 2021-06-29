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


@propertyWrapper
final public class JSON<Wrapper>: BaseFiled<Wrapper> where Wrapper: Codable {
    public override var wrappedValue: Wrapper {
        get { super.wrappedValue }
        set { super.wrappedValue = newValue }
    }
}
