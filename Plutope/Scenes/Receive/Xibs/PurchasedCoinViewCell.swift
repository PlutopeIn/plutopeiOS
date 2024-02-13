//
//  PurchasedCoinViewCell.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
class PurchasedCoinViewCell: UITableViewCell, Reusable {
    @IBOutlet weak var lblPer: UILabel!
    @IBOutlet weak var ivCoin: UIImageView!
    @IBOutlet weak var lblCoinName: UILabel!
    @IBOutlet weak var lblSymbol: UILabel!
    @IBOutlet weak var coinPrice: UILabel!
    @IBOutlet weak var coinQuantity: UILabel!
    @IBOutlet weak var coinAmount: UILabel!
    
    @IBOutlet weak var lblYourTokens: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 10
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
