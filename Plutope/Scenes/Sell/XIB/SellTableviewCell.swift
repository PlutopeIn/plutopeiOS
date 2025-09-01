//
//  SellTableviewCell.swift
//  Plutope
//
//  Created by Trupti Mistry on 22/04/25.
//

import UIKit

class SellTableviewCell: UITableViewCell,Reusable {

    @IBOutlet weak var ivProvider: UIImageView!
    @IBOutlet weak var lblProviderName: UILabel!
    
    @IBOutlet weak var viewBottom: UIView!
    let providerName = ""
    let provioderUrl = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblProviderName.font = AppFont.regular(15).value
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
