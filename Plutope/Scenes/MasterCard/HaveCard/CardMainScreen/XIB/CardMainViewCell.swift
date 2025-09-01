//
//  CardMainViewCell.swift
//  Plutope
//
//  Created by Trupti Mistry on 16/05/24.
//

import UIKit

class CardMainViewCell: UITableViewCell , Reusable {

    @IBOutlet weak var lblkycUpdate: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
