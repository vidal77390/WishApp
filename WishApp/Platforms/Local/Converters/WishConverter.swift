//
//  WishConverter.swift
//  WishApp
//
//  Created by Dmytro LUTSYK on 21/01/2021.
//

import Foundation

class WishConverter: Converter {
    
    struct Keys {
        public static let id = "id"
        public static let name = "name"
        public static let message = "message"
    }
    
    typealias Obj = Wish
    
    static func toDictionary(_ obj: Wish) -> [String : Any] {
        return [
            Keys.id: obj.id,
            Keys.name: obj.name,
            Keys.message: obj.message
        ]
    }
    
    static func toObject(_ dict: [String : Any]) -> Wish? {
        guard let id = dict[Keys.id] as? String,
              let name = dict[Keys.name] as? String,
              let message = dict[Keys.message] as? String else {
            return nil
        }
        return Wish(id: id, name: name, message: message)
    }
}
