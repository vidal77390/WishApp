//
//  File.swift
//  WishApp
//
//  Created by Dmytro LUTSYK on 21/01/2021.
//

import Foundation

class Wish {
    let id: String
    let name: String
    let message: String
    
    init(id: String, name: String, message: String){
        self.id = id
        self.name = name
        self.message = message
    }
}
