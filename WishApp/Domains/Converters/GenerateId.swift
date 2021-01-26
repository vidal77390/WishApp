//
//  GenerateId.swift
//  WishApp
//
//  Created by Dmytro LUTSYK on 26/01/2021.
//

import Foundation

class GenerateId {
    
    private static var caracters = "azertyuiopqsdfghjklmwxcvbn123456789"
    
    public static func generate(length: Int) -> String {
        var res = ""
        for _ in 0 ..< length {
            res += String(caracters.randomElement()!)
        }
        return res
    }
    
}
