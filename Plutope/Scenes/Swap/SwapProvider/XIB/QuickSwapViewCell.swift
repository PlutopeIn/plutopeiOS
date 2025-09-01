//
//  QuickSwapViewCell.swift
//  Plutope
//
//  Created by Trupti Mistry on 30/07/24.
//

import UIKit

class QuickSwapViewCell: UICollectionViewCell,Reusable {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblSwapCoins: UILabel!
    @IBOutlet weak var ivCoin: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
