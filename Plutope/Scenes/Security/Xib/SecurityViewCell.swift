//
//  SecurityViewCell.swift
//  Plutope
//
//  Created by Priyanka Poojara on 20/06/23.
//
import UIKit
class SecurityViewCell: UITableViewCell, Reusable {
    @IBOutlet weak var ivForward: UIImageView!
    @IBOutlet weak var viewSwitch: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var switchSecurity: UISwitch!
    @IBOutlet weak var viewForward: UIView!
    
    @IBOutlet weak var lblSelectedMethod: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
