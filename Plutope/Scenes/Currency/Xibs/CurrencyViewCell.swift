//
//  CurrencyViewCell.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
class CurrencyViewCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var ivSelected: UIImageView!
    @IBOutlet weak var lblCurrency: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblCurrency.font = AppFont.violetRegular(16).value
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
