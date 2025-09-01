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
    
    @IBOutlet weak var viewTransactionIV: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    var isToContract  = false
    var priceSsymbol = ""
    var headerTitle = ""
    @IBOutlet weak var ivTansaction: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblStatus.font = AppFont.violetRegular(9).value
        lblTitle.font = AppFont.violetRegular(17).value
        lblDescription.font = AppFont.violetRegular(12).value
        lblDuration.font = AppFont.violetRegular(12).value
        lblPrice.font = AppFont.violetRegular(13).value
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
