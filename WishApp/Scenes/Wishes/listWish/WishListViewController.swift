//
//  WishListViewController.swift
//  WishApp
//
//  Created by Dmytro LUTSYK on 21/01/2021.
//

import UIKit

class WishListDetailViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let wishService: WishListService = LocalWishListService.shared
    var wishList: WishList!
    
    class func newInstance(wishList: WishList) -> WishListDetailViewController {
        let WLDetailController = WishListDetailViewController()
        WLDetailController.wishList = wishList
        print("initt \(WLDetailController.wishList.listOfWish)")
        return WLDetailController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("wiewdidload")
        self.title = wishList.name
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Set Navigation Bar Button
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createWish))
        let leftBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(activateEditMode))
        let barButtonColor: UIColor = UIColor(cgColor: CGColor(red: CGFloat(0.09), green: CGFloat(0.5), blue: CGFloat(0.09), alpha: CGFloat(1.0)))
        rightBarButton.tintColor = barButtonColor
        leftBarButton.tintColor = barButtonColor
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton

    }
    
    @objc
    func activateEditMode() {
        UIView.animate(withDuration: 0.33) {
            self.tableView.isEditing = !self.tableView.isEditing
        }
    }
    
    @objc
    func createWish() {
        var nameTextField: UITextField!
        let alertController = UIAlertController(title: "New Wish !", message: "Veuillez saisir le nom de votre Wish", preferredStyle: .alert)
        alertController.addTextField { (txtName) -> Void in
            nameTextField = txtName
            nameTextField.placeholder = "Nom"
        }
        
        let createAction = UIAlertAction(title: "createWish", style: .default) { (action) -> Void in
            let name: String = nameTextField.text!
            if(!name.isEmpty){
                let newWish = Wish(name: name, message: "")
                guard let updatedWishList = self.wishList else {
                    return
                }
                updatedWishList.listOfWish.append(newWish)
                self.wishService.update(wishList: updatedWishList, completion: {(err, isUpdated) in
                    if(isUpdated) { self.setWishList(updatedWishList) }
                })
                
            }
        }
        
        alertController.addAction(createAction)
        present(alertController, animated: true, completion: {
            alertController.view.superview?.isUserInteractionEnabled = true
            alertController.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapOutside)))
        })
    
    }
    
    @objc
    func tapOutside() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*@IBAction func touchNext(_ sender: Any) {
        guard let selectedRows = self.tableView.indexPathsForSelectedRows else {
            return
        }
        var selectedWishes: [Wish] = []
        for i in 0 ..< selectedRows.count {
            let selectedIndexPath = selectedRows[i]
            self.wishList.listOfWish.append(self.wishList[selectedIndexPath.row])
        }
    }*/
}



extension WishListDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func dequeueOrCreateWishCell(_ tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "wish_cell") else {
            return UITableViewCell(style: .default, reuseIdentifier: "wish_cell")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueOrCreateWishCell(tableView)
        let wish = self.wishList.listOfWish[indexPath.row]
        cell.textLabel?.text = wish.name
        cell.detailTextLabel?.text = "\(wish.message)"
        return cell
    }
    
    func setWishList(_ wishList: WishList) {
        self.wishList = wishList
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wishList.listOfWish.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wish = self.wishList.listOfWish[indexPath.row]
        let detail = WishDetailViewController.newInstance(wish: wish)
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let updatedWishList = self.wishList else {
            return
        }
        updatedWishList.listOfWish.remove(at: indexPath.row)
        self.wishService.update(wishList: updatedWishList, completion: {(err, isUpdated) in
            if(isUpdated) { self.setWishList(updatedWishList) }
        })
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let updatedWishList = self.wishList else {
            return
        }
        let res = updatedWishList.listOfWish[sourceIndexPath.row]
        updatedWishList.listOfWish.remove(at: sourceIndexPath.row)
        updatedWishList.listOfWish.insert(res, at: destinationIndexPath.row)
        self.wishService.update(wishList: updatedWishList, completion: {(err, isUpdated) in
            if(isUpdated) { self.setWishList(updatedWishList) }
        })
    }
}

