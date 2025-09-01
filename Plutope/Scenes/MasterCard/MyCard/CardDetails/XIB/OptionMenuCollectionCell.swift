//
//  OptionMenuCollectionCell.swift
//  Plutope
//
//  Created by Naeem Ajmeri on 22/08/24.
//

import UIKit

class OptionMenuCollectionCell: UICollectionViewCell, Reusable {
    
    @IBOutlet weak var imgOptions: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lblTitle.font = AppFont.violetRegular(12.0).value
    }

}
