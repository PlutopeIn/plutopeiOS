//
//  SettingViewCell.swift
//  Plutope
//
//  Created by Priyanka Poojara on 09/06/23.
//
import UIKit
class SettingViewCell: UITableViewCell, Reusable {
    @IBOutlet weak var ivForward: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var ivSettings: UIImageView!
    @IBOutlet weak var ivSettingHeight: NSLayoutConstraint!
    @IBOutlet weak var ivSettingWidth: NSLayoutConstraint!
    
    @IBOutlet weak var footerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblTitle.font = AppFont.regular(16).value
        lblSubtitle.font = AppFont.regular(13).value
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
