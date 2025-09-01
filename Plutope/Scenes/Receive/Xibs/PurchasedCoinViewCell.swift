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
    override func awakeFromNib() {
        super.awakeFromNib()
        lblCoinName.font = AppFont.violetRegular(12.6).value
        coinQuantity.font = AppFont.violetRegular(12.6).value
        coinAmount.font = AppFont.violetRegular(11.6).value
        lblSymbol.font = AppFont.violetRegular(8.2).value
        coinPrice.font = AppFont.regular(10.2).value
        lblPer.font = AppFont.regular(10.2).value
        
      
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
