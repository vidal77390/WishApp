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
}


class Wish {
    let name: String
    var message: String
    
    init(name: String, message: String){
        self.name = name
        self.message = message
    }
}
