//
//  CardHistryTbvCell.swift
//  Plutope
//
//  Created by Trupti Mistry on 01/01/24.
//

import UIKit

class CardHistryTbvCell: UITableViewCell ,Reusable {

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    var isToContract  = false
    var priceSsymbol = ""
    var headerTitle = ""
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
