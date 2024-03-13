//
//  CardWalletTableViewCell.swift
//  Plutope
//
//  Created by Trupti Mistry on 10/08/23.
//

import UIKit

class CardWalletTableViewCell: UITableViewCell ,Reusable {

    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var ivSymbol: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
