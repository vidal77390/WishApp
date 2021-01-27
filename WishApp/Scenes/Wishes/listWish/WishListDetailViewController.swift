//
//  WishListDetailViewController.swift
//  WishApp
//
//  Created by VIDAL Léo on 25/01/2021.
//

//
//  WishListViewController.swift
//  WishApp
//
//  Created by Dmytro LUTSYK on 21/01/2021.
//

import UIKit

class WishListDetailViewController: UIViewController {
    
    enum Identifier: String {
        case Wish
    }
    
    @IBOutlet var tableView: UITableView!
    
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
        
        self.tableView.register(UINib(nibName: "WishTableViewCell", bundle: nil), forCellReuseIdentifier: Identifier.Wish.rawValue)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.testIfListEmpty()
        
        
        // Set Navigation Bar Button
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createWish))
        let barButtonColor: UIColor = UIColor(cgColor: CGColor(red: CGFloat(0.13), green: CGFloat(0.40), blue: CGFloat(2.19), alpha: CGFloat(1.0)))
        rightBarButton.tintColor = barButtonColor
        navigationItem.rightBarButtonItem = rightBarButton

    }
    
    func setWishList(_ wishList: WishList) {
        self.wishList = wishList
        self.tableView.reloadData()
        self.testIfListEmpty()
    }
    
    
    func testIfListEmpty() {
        if(self.wishList.listOfWish.count == 0) { self.tableView.isHidden = true}
        else { self.tableView.isHidden = false }
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
                let newWish = Wish(name: name, message: "", id: GenerateId.generate(length: 32))
                guard let updatedWishList = self.wishList else {
                    return
                }
                // Si le nom est deja prit present ErrorAlert
                print("wishes : ")
                updatedWishList.listOfWish.forEach { wish in print("\(wish.name)")}
                let indexOfWish = updatedWishList.listOfWish.firstIndex { $0.name == newWish.name }
                if(indexOfWish != nil) { self.presentErrorAlert() }
                else {
                    updatedWishList.listOfWish.append(newWish)
                    print("list updated : \(updatedWishList)")
                    self.wishService.update(wishList: updatedWishList, completion: {(err, isUpdated) in
                        if(isUpdated) { self.setWishList(updatedWishList) }
                    })
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
    
    func presentErrorAlert()-> Void {
        let alert = UIAlertController(title: "Erreur de création", message: "Veuillez saisir un nom unique", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }))
        present(alert, animated: true, completion: {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapOutside)))
        })
    }
    
}



extension WishListDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.Wish.rawValue, for: indexPath) as! WishTableViewCell
        let wish = self.wishList.listOfWish[indexPath.row]
        cell.nameLabel.text = wish.name
        cell.selectionStyle = .none
        return cell
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


