//
//  SwapProvidersViewCell.swift
//  Plutope
//
//  Created by Trupti Mistry on 31/10/23.
//

import UIKit

class SwapProvidersViewCell: UITableViewCell,Reusable {

    @IBOutlet weak var lblSwapperFee: UILabel!
    @IBOutlet weak var ivProvider: UIImageView!
    @IBOutlet weak var lblProviderName: UILabel!
    @IBOutlet weak var lblBestPrice: UILabel!
    var quotAmount = ""
   @IBOutlet weak var lblDiffrence: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblProviderName.font = AppFont.regular(15).value
        lblBestPrice.font = AppFont.regular(15).value
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
