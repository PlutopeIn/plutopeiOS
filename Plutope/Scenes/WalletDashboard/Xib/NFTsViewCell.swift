//
//  NFTsViewCell.swift
//  Plutope
//
//  Created by Priyanka Poojara on 13/06/23.
//
import UIKit
class NFTsViewCell: UICollectionViewCell, Reusable {
    @IBOutlet weak var ivNFT: UIImageView!
    @IBOutlet weak var bgViewNFTName: UIView!
    @IBOutlet weak var lblNftName: UILabel!
    
    var nftDescription: String = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        ivNFT.layer.cornerRadius = 10
        bgViewNFTName.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        bgViewNFTName.layer.cornerRadius = 10
     } 
 } 
