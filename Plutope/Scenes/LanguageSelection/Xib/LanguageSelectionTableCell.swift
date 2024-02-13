//
//  LanguageSelectionTableCell.swift
//  Plutope
//
//  Created by Admin on 07/11/23.
//

import UIKit

class LanguageSelectionTableCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCheckUnCheck: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
