//
//  WishService.swift
//  WishApp
//
//  Created by Dmytro LUTSYK on 21/01/2021.
//

import Foundation

protocol WishListService {
    func create(wishList: WishList, completion: @escaping (Error?, WishList?) -> Void)
    func remove(wishList: WishList, completion: @escaping (Error?, Bool) -> Void)
    func list(completion: @escaping (Error?, [WishList]) -> Void)
    func clear(completion: @escaping (Error?) -> Void)
}
