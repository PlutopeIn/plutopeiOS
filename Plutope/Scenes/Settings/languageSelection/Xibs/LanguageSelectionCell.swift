//
//  LanguageSelectionCell.swift
//  Plutope
//
//  Created by Pushpendra Rajput on 01/08/24.
//

import UIKit

class LanguageSelectionCell: UITableViewCell, Reusable {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgSelection: UIImageView!
    @IBOutlet weak var lblLanguageName: UILabel!
    @IBOutlet weak var imgFlag: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblLanguageName.font = AppFont.violetRegular(16).value
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
