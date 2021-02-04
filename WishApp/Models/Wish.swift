//
//  File.swift
//  WishApp
//
//  Created by Dmytro LUTSYK on 21/01/2021.
//

import Foundation


class WishList {
    let name: String
    var listOfWish: [Wish]
    
    init(name: String) {
        self.name = name
        self.listOfWish = []
    }
    
    init(name: String, listOfWish: [Wish]) {
        self.name = name
        self.listOfWish = listOfWish
    }
    
    func toMessageString() -> String{
        var message: String = String(self.name) + ":\n"
        for wish in self.listOfWish{
            message += "\t" + String(wish.name) + " - " + String(wish.message) + "\n"
        }
        
        return message
    }
}


class Wish {
    let name: String
    var message: String
    let id: String
    
    init(name: String, message: String, id: String){
        self.name = name
        self.message = message
        self.id = id
    }
}
