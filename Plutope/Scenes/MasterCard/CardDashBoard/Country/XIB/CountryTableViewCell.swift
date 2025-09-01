//
//  CountryTableViewCell.swift
//  Plutope
//
//  Created by Trupti Mistry on 30/06/24.
//

import UIKit

class CountryTableViewCell: UITableViewCell,Reusable {

    @IBOutlet weak var lblFlag: UILabel!
    @IBOutlet weak var lblToken: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
