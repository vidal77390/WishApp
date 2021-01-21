//
//  WishService.swift
//  WishApp
//
//  Created by Dmytro LUTSYK on 21/01/2021.
//

import Foundation

protocol WishService {
    func create(dto: WishCreateDTO, completion: @escaping (Error?, Wish?) -> Void)
    func list(completion: @escaping (Error?, [Wish]) -> Void)
    func clear(completion: @escaping (Error?) -> Void)
}
