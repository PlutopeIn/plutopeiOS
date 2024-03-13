//
//  ENSViewCell.swift
//  Plutope
//
//  Created by Trupti Mistry on 02/01/24.
//

import UIKit

class ENSViewCell: UITableViewCell ,Reusable {
  
    @IBOutlet weak var btnWidth: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
