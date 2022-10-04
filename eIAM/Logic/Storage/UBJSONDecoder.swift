//
//  JSONEncoder+pre13.swift
//  eIAM
//
//  Created by Stefan Mitterrutzner on 09.12.21.
//

import Foundation

public class UBJSONDecoder: JSONDecoder {
    override public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        if #available(iOS 13.1, *) {
            return try super.decode(type, from: data)
        } else {
            // workaround if object is top level to support pre 13.1
            if T.self == Date?.self ||
                T.self == Bool?.self ||
                T.self == Date.self ||
                T.self == Bool.self ||
                T.self == String.self ||
                T.self == String?.self {
                let encodedString = String(data: data, encoding: .utf8)!
                let wrappedElement = "[\(encodedString)]"
                let collection = try super.decode([T].self, from: wrappedElement.data(using: .utf8)!)
                return collection.first!
            } else {
                return try super.decode(type, from: data)
            }
        }
    }
}
