//
//  LocalWishService.swift
//  WishApp
//
//  Created by Dmytro LUTSYK on 21/01/2021.
//

import Foundation


class LocalWishListService: WishListService {

    static let shared = LocalWishListService()
    
    private init() { }
    
    func create(wishList: WishList, completion: @escaping (Error?, WishList?) -> Void) {
        self.read { (_, listOfWishList) in
            var newListOfWishList = listOfWishList
            newListOfWishList.append(wishList)
            self.write(newListOfWishList) { (err) in
                completion(err, wishList)
            }
        }
    }
    
    func remove(wishList: WishList, completion: @escaping (Error?, Bool) -> Void) {
        self.read { (_, list) in
            var newListOfWishList = list
            newListOfWishList.removeAll { $0.name == wishList.name }
            self.write(newListOfWishList, completion: {(err) in
                completion(err, true)
            })
        }
    }
    
    func update(wishList: WishList, completion: @escaping (Error?, Bool) -> Void) {
        self.read(completion: { (err, list) in
            var newList = list
            let indexOfWishList = newList.firstIndex { $0.name == wishList.name}
            guard let index = indexOfWishList else {
                completion(NSError(domain: "updateWishList", code: 504, userInfo: nil), false)
                return
            }
            newList[index] = wishList
            self.write(newList, completion: {err in
                completion(err, true)
            })
        })
    }
    
    func updateList(wishListTab: [WishList], completion: @escaping (Error?, Bool) -> Void) {
        self.write(wishListTab, completion: { err in completion(err, true) } )
    }
    
    func list(completion: @escaping (Error?, [WishList]) -> Void) {
        self.read(completion: completion)
    }
      
    func write(_ wishList: [WishList], completion: @escaping (Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let dicts = wishList.compactMap(WishListConverter.toDictionary(_:))
            do {
                let json = try JSONSerialization.data(withJSONObject: dicts, options: .fragmentsAllowed)
                
                guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    DispatchQueue.main.sync { // propagation sur le main thread (raison: UI)
                        completion(NSError(domain: "com.wishapp", code: 1, userInfo: [
                            NSLocalizedDescriptionKey: "Document directory not found"
                        ]))
                    }
                    return
                }
                let wishListURL = documentDirectory.appendingPathComponent("wishList.json")
                try json.write(to: wishListURL)
                DispatchQueue.main.sync { // propagation sur le main thread (raison: UI)
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.sync { // propagation sur le main thread (raison: UI)
                    completion(error)
                }
            }
        }
    }
    
    func read(completion: @escaping (Error?, [WishList]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                DispatchQueue.main.sync { // propagation sur le main thread (raison: UI)
                    completion(NSError(domain: "com.testapp", code: 1, userInfo: [
                        NSLocalizedDescriptionKey: "Document directory not found"
                    ]), [])
                }
                return
            }
            let wishListURL = documentDirectory.appendingPathComponent("wishList.json")
            do {
                let data = try Data(contentsOf: wishListURL)
                let dicts = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String: Any]]
                let wishList = dicts.compactMap(WishListConverter.toObject(_:))
                DispatchQueue.main.sync { // propagation sur le main thread (raison: UI)
                    completion(nil, wishList)
                }
            } catch {
                DispatchQueue.main.sync { // propagation sur le main thread (raison: UI)
                    completion(error, [])
                }
            }
        }
    }
    
}
