//
//  Decoder.swift
//  MTTTestProject
//
//  Created by Aleš Kocur on 05/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import JASON

protocol DecodableManagedObject {
    typealias DecodedType = Self
    func decode(json: JSON)
    static func newObject(json: JSON) -> DecodedType
}

extension CollectionType where Generator.Element: DecodableManagedObject, Generator.Element == Generator.Element.DecodedType {
    
    static func decode(json: [JSON]) -> [Generator.Element] {
        
        return json.map { json in
            let object = Generator.Element.newObject(json)
            object.decode(json)
            
            return object
        }
    }
    
}

class Decoder {
    class func decode<T where T: DecodableManagedObject, T == T.DecodedType>(json: JSON) -> T? {
        let object = T.newObject(json)
        object.decode(json)
        
        return object
    }
    
    class func decode<T where T: DecodableManagedObject, T == T.DecodedType>(json: [JSON]) -> [T]? {
        return Array<T>.decode(json)
    }

}