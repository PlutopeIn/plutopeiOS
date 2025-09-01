//
//  CardUsersProfileTableViewCell.swift
//  Plutope
//
//  Created by Trupti Mistry on 22/05/24.
//

import UIKit

class CardUsersProfileTableViewCell: UITableViewCell ,Reusable {
    @IBOutlet weak var lblOtherSetails: UILabel!
    
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ivIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
