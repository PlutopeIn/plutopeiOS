//
//  CoinListViewCell.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
class CoinListViewCell: UITableViewCell, Reusable {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblCoinQuantity: UILabel!
    @IBOutlet weak var ivCoin: UIImageView!
    @IBOutlet weak var lblCoinName: UILabel!
    @IBOutlet weak var lblSymbol: UILabel!
   
    @IBOutlet weak var lblType: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
     } 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
     } 
    
 } 
