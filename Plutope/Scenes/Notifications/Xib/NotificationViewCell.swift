//
//  NotificationViewCell.swift
//  Plutope
//
//  Created by Priyanka Poojara on 08/06/23.
//
import UIKit
class NotificationViewCell: UITableViewCell, Reusable {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
