//
//  ReferralUserCell.swift
//  Plutope
//
//  Created by Pushpendra Rajput on 12/07/24.
//

import UIKit

class ReferralUserCell: UITableViewCell, Reusable {
    @IBOutlet weak var lblWalletName: UILabel!
    @IBOutlet weak var imgCopy: UIImageView!
    @IBOutlet weak var lblwalletAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblWalletName.font = AppFont.violetRegular(12).value
        lblwalletAddress.font = AppFont.regular(12).value
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
