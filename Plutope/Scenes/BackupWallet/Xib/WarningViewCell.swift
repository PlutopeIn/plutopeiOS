//
//  WarningViewCell.swift
//  Plutope
//
//  Created by Priyanka on 02/06/23.
//
import UIKit
class WarningViewCell: UITableViewCell, Reusable {
    @IBOutlet weak var lblWarning: UILabel!
    @IBOutlet weak var ivCheck: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblWarning.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.iflosemysecretphrasemyfundswillbelostforever, comment: "")
        lblWarning.font = AppFont.regular(14).value
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
