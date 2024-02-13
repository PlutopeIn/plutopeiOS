//
//  TransactionViewCell.swift
//  Plutope
//
//  Created by Priyanka on 10/06/23.
//
import UIKit
class TransactionViewCell: UITableViewCell, Reusable {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    
    @IBOutlet weak var ivTansaction: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
