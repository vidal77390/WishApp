//
//  WishTableViewCell.swift
//  WishApp
//
//  Created by Dmytro LUTSYK on 22/01/2021.
//

import UIKit

class WishTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func touchStep(_ sender: UIStepper) {
        print("\(sender.value)")
    }
}
