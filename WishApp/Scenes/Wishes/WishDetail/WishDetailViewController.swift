//
//  WishDetailViewController.swift
//  WishApp
//
//  Created by Dmytro LUTSYK on 22/01/2021.
//

import UIKit

class WishDetailViewController: UIViewController {
    
    var wish: Wish!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    class func newInstance(wish: Wish) -> WishDetailViewController {
        let wishDetailViewController = WishDetailViewController()
        wishDetailViewController.wish = wish
        return wishDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.wish.name
        self.nameLabel.text = self.wish.name
        self.descriptionLabel.text = self.wish.message
        

        // Do any additional setup after loading the view.
    }
}

