//
//  WalletConnectPopupTbvCell.swift
//  Plutope
//
//  Created by Trupti Mistry on 25/01/24.
//

import UIKit

class WalletConnectPopupTbvCell: UITableViewCell ,Reusable {

    @IBOutlet weak var ivAccessblity: UIImageView!
    @IBOutlet weak var ivConnection: UIImageView!
    @IBOutlet weak var lblUrl: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ivWallet: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
