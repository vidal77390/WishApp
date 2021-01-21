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
        self.title = "Wishes"
        self.tableView.delegate = self
        self.tableView.dataSource = self

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
    
    @IBAction func touchNext(_ sender: Any) {
        guard let selectedRows = self.tableView.indexPathsForSelectedRows else {
            return
        }
        var selectedWishes: [Wish] = []
        for i in 0 ..< selectedRows.count {
            let selectedIndexPath = selectedRows[i]
            selectedWishes.append(self.wishList[selectedIndexPath.row])
        }
        }
}

extension WishListViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func dequeueOrCreateWishCell(_ tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "wish_cell") else {
            return UITableViewCell(style: .default, reuseIdentifier: "wish_cell")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueOrCreateWishCell(tableView)
        let wish = self.wishList[indexPath.row]
        cell.textLabel?.text = wish.name
        cell.detailTextLabel?.text = "\(wish.message)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wishList.count
    }
}

