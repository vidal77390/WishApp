//
//  HomeViewController.swift
//  WishApp
//
//  Created by VIDAL Léo on 03/01/2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    enum Identifier: String {
        case WishList
    }
    var listOfWishList: [WishList] = []
        
    let wishListService: WishListService = LocalWishListService.shared

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set Navigation Bar Button
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createWishList))
        let leftBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(activateEditMode))
        let barButtonColor: UIColor = UIColor(cgColor: CGColor(red: CGFloat(0.13), green: CGFloat(0.40), blue: CGFloat(2.19), alpha: CGFloat(1.0)))
        rightBarButton.tintColor = barButtonColor
        leftBarButton.tintColor = barButtonColor
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
        
        self.tableView.register(UINib(nibName: "WishListTableViewCell", bundle: nil), forCellReuseIdentifier: Identifier.WishList.rawValue)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.getAndSetListOfWishList()
                
    }
    
    func getAndSetListOfWishList() {
        self.wishListService.list(completion: { err, list in
            self.listOfWishList = list
            if(self.listOfWishList.count == 0) { self.tableView.isHidden = true }
            else { self.tableView.isHidden = false}
            self.tableView.reloadData()
            print("list : \(list)")
        })
    }
    
    @objc
    func activateEditMode(){
        UIView.animate(withDuration: 0.33, animations: {
            self.tableView.isEditing = !self.tableView.isEditing
        })
    }
    
    @objc
    func createWishList() -> Void {
        var nameTextField: UITextField!
        let alertController = UIAlertController(title: "New WishList !", message: "Veuillez saisir le nom de votre WishList", preferredStyle: .alert)
        alertController.addTextField { (txtName) -> Void in
            nameTextField = txtName
            nameTextField.placeholder = "Nom"
        }
        
        let createAction = UIAlertAction(title: "createWishList", style: .default) { (action) -> Void in
            let name: String = nameTextField.text!
            if(!name.isEmpty){
                let wishList = WishList(name: name)
                self.wishListService.create(wishList: wishList) { (err, wish) in
                    guard err == nil else {
                        let alert = UIAlertController(title: "Erreur de création", message: "Veuillez saisir un nom unique", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                            alert.dismiss(animated: true)
                        }))
                        self.present(alert, animated: true)
                        return
                    }
                    print("wishlist created with : \(nameTextField.text!)")
                    self.getAndSetListOfWishList()
                    self.navigationController?.popViewController(animated: true)
                }
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
    
    
    func goToWishListDetail(wishList: WishList) {
        let WLDetailController = WishListDetailViewController.newInstance(wishList: wishList)
        self.navigationController?.pushViewController(WLDetailController, animated: true)
    }
    

}




extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.listOfWishList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.WishList.rawValue, for: indexPath) as! WishListTableViewCell
        let wishList = self.listOfWishList[indexPath.row]
        cell.nameLabel.text = wishList.name
        cell.nameLabel.textColor =  UIColor(cgColor: CGColor(red: CGFloat(0.13), green: CGFloat(0.40), blue: CGFloat(2.19), alpha: CGFloat(1.0)))
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let deletedWishList = self.listOfWishList[indexPath.row]
        self.wishListService.remove(wishList: deletedWishList, completion: {(err, isDeleted) in
            if(isDeleted){
                self.getAndSetListOfWishList()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tmp = self.listOfWishList[sourceIndexPath.row]
        self.listOfWishList.remove(at: sourceIndexPath.row)
        self.listOfWishList.insert(tmp, at: destinationIndexPath.row)
        self.wishListService.updateList(wishListTab: self.listOfWishList, completion: {(err, isUpdated) in })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.goToWishListDetail(wishList: self.listOfWishList[indexPath.row])
    }
    
    
}




