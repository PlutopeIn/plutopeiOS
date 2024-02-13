//
//  WalletBackupViewCell.swift
//  Plutope
//
//  Created by Priyanka Poojara on 20/06/23.
//
import UIKit
class WalletBackupViewCell: UITableViewCell, Reusable {
    @IBOutlet weak var lblWalletName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
