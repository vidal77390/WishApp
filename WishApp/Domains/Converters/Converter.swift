//
//  Converter.swift
//  WishApp
//
//  Created by Dmytro LUTSYK on 21/01/2021.
//

import Foundation

protocol Converter {
    associatedtype Obj
    
    static func toDictionary(_ obj: Obj) -> [String: Any]
    static func toObject(_ dict: [String: Any]) -> Obj?
}
