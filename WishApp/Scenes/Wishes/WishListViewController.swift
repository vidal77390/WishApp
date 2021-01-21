//
//  WishListViewController.swift
//  WishApp
//
//  Created by Dmytro LUTSYK on 21/01/2021.
//

import UIKit

class WishListViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    let wishService: WishService = LocalWishService.shared
    var wishList: [Wish] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.wishService.list { (err, wishList) in
            guard err == nil else {
                self.wishList = []
                return
            }
            self.wishList = wishList
        }
    }

}
