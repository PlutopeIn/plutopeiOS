//
//  SwapProvidersViewCell.swift
//  Plutope
//
//  Created by Trupti Mistry on 31/10/23.
//

import UIKit

class SwapProvidersViewCell: UITableViewCell,Reusable {

    @IBOutlet weak var lblProviderName: UILabel!
    @IBOutlet weak var lblBestPrice: UILabel!
    
    @IBOutlet weak var lblDiffrence: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
