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
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
