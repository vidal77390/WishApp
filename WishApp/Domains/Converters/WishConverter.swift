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
    }
    
    typealias Obj = Wish
    
    static func toDictionary(_ obj: Wish) -> [String : Any] {
        return [
            Keys.name: obj.name,
            Keys.message: obj.message
        ]
    }
    
    static func toObject(_ dict: [String : Any]) -> Wish? {
        guard let name = dict[Keys.name] as? String,
              let message = dict[Keys.message] as? String else {
            return nil
        }
        return Wish(name: name, message: message)
    }
}
