//
//  WalletsViewCell.swift
//  Plutope
//
//  Created by Priyanka Poojara on 16/06/23.
//
import UIKit
class WalletsViewCell: UITableViewCell, Reusable {
    @IBOutlet weak var ivCheckWallet: UIImageView!
    @IBOutlet weak var lblWalletName: UILabel!
    @IBOutlet weak var lblWalletType: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
