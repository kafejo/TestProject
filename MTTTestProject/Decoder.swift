//
//  Decoder.swift
//  MTTTestProject
//
//  Created by Aleš Kocur on 05/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import JASON
import CoreData

protocol DecodableManagedObject {
    typealias DecodedType = Self
    func decode(json: JSON, context: NSManagedObjectContext)
    static func newObject(json: JSON, context: NSManagedObjectContext) -> DecodedType
}

extension CollectionType where Generator.Element: DecodableManagedObject, Generator.Element == Generator.Element.DecodedType {
    
    static func decode(json: [JSON], context: NSManagedObjectContext) -> [Generator.Element] {
        
        return json.map { json in
            let object = Generator.Element.newObject(json, context: context)
            object.decode(json, context: context)
            
            return object
        }
    }
    
}

class Decoder {
    class func decode<T where T: DecodableManagedObject, T == T.DecodedType>(json: JSON, context: NSManagedObjectContext) -> T? {
        let object = T.newObject(json, context: context)
        object.decode(json, context: context)
        
        return object
    }
    
    class func decode<T where T: DecodableManagedObject, T == T.DecodedType>(json: [JSON], context: NSManagedObjectContext) -> [T]? {
        return Array<T>.decode(json, context: context)
    }

}