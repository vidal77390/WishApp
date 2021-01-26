//
//  WishListConverter.swift
//  WishApp
//
//  Created by VIDAL Léo on 24/01/2021.
//

import Foundation

class WishListConverter: Converter {
    
    struct Keys {
        public static let name = "name"
        public static let listOfWish = "listOfWish"
    }
    
    typealias Obj = WishList
    
    static func toDictionary(_ obj: WishList) -> [String : Any] {
        let dictOfListWish = obj.listOfWish.compactMap { wish in
            WishConverter.toDictionary(wish)
        }
        return [
            Keys.name: obj.name,
            Keys.listOfWish: dictOfListWish
        ]
    }
    
    static func toObject(_ dict: [String : Any]) -> WishList? {
        guard let name = dict[Keys.name] as? String,
              let dictListOfWish = dict[Keys.listOfWish] as? [[String:Any]] else {
            return nil
        }
        let listOfWish: [Wish] = dictListOfWish.compactMap { dictWish in
            return WishConverter.toObject(dictWish)
        }
        return WishList(name: name, listOfWish: listOfWish)
    }
}
