//
//  LocalWishService.swift
//  WishApp
//
//  Created by Dmytro LUTSYK on 21/01/2021.
//

import Foundation


class LocalWishService: WishService {
    
    static let shared = LocalWishService()
    
    private init() { }
    
    func create(dto: WishCreateDTO, completion: @escaping (Error?, Wish?) -> Void) {
        self.read { (_, wishList) in
            var newWishList = wishList
            let res = Wish(id: RandomId.generate(length: 32), name: dto.name, message: dto.message)
            newWishList.append(res)
            self.write(newWishList) { (err) in
                completion(err, res)
            }
        }
    }
    
    func list(completion: @escaping (Error?, [Wish]) -> Void) {
        self.read(completion: completion)
    }
    
    func clear(completion: @escaping (Error?) -> Void) {
        completion(nil)
    }
      
    func write(_ wishList: [Wish], completion: @escaping (Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let dicts = wishList.compactMap(WishConverter.toDictionary(_:))
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
    
    func read(completion: @escaping (Error?, [Wish]) -> Void) {
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
                let wishList = dicts.compactMap(WishConverter.toObject(_:))
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
