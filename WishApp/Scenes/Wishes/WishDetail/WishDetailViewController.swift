//
//  WishDetailViewController.swift
//  WishApp
//
//  Created by Dmytro LUTSYK on 22/01/2021.
//

import UIKit

class WishDetailViewController: UIViewController {
    
    var wish: Wish!
    let wishService: WishListService = LocalWishListService.shared
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    class func newInstance(wish: Wish) -> WishDetailViewController {
        let wishDetailViewController = WishDetailViewController()
        wishDetailViewController.wish = wish
        return wishDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.wish.name
        self.nameTextField.text = self.wish.name
        self.nameTextField.isEnabled = false
        self.nameTextField.textColor = UIColor(cgColor: CGColor(red: CGFloat(0.46), green: CGFloat(0.49), blue: CGFloat(0.49), alpha: CGFloat(1.0)))
        self.descriptionTextField.text = self.wish.message
        print("wish id: \(self.wish.id)")
        
        // Set Navigation Bar Button
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(updateWish))
        let barButtonColor: UIColor = UIColor(cgColor: CGColor(red: CGFloat(0.13), green: CGFloat(0.40), blue: CGFloat(2.19), alpha: CGFloat(1.0)))
        rightBarButton.tintColor = barButtonColor
        navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    @objc
    func updateWish() {
        guard let description = descriptionTextField.text else {
            return
        }
        let updateWish: Wish = self.wish
        updateWish.message = description
        if(!description.isEmpty){
            self.wishService.updateWish(wish: updateWish, completion: {(err, isUpdated) in
            })
            
        }
    }
    
    @objc
    func tapOutside() {
        self.dismiss(animated: true, completion: nil)
    }
}


