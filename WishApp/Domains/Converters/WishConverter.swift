//
//  WishConverter.swift
//  WishApp
//
//  Created by Dmytro LUTSYK on 21/01/2021.
//

import Foundation

class WishConverter: Converter {
    
    
    struct Keys {
        public static let name = "name"
        public static let message = "message"
        public static let id = "id"
    }
    
    typealias Obj = Wish
    
    static func toDictionary(_ obj: Wish) -> [String : Any] {
        return [
            Keys.name: obj.name,
            Keys.message: obj.message,
            Keys.id: obj.id
        ]
    }
    
    static func toObject(_ dict: [String : Any]) -> Wish? {
        guard let name = dict[Keys.name] as? String,
              let message = dict[Keys.message] as? String,
              let id = dict[Keys.id] as? String
              else {
            return nil
        }
        return Wish(name: name, message: message, id: id)
    }
}
