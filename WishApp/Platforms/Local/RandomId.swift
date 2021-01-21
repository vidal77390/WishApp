//
//  RandomId.swift
//  WishApp
//
//  Created by Dmytro LUTSYK on 21/01/2021.
//

import Foundation

class RandomId {
    
    private static var letters = "azertyuiopqsdfghjklmwxcvbn123456789"
    
    public static func generate(length: Int) -> String {
        var res = ""
        for _ in 0 ..< length {
            res += String(letters.randomElement()!)
        }
        return res
    }
    
}
