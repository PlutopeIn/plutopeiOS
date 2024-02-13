//
//  NFTDescriptionViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 29/06/23.
//

import UIKit
import SDWebImage

class NFTDescriptionViewController: UIViewController {

    @IBOutlet weak var lblNFTName: UILabel!
    @IBOutlet weak var ivNFT: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    
    var nftName: String = String()
    var nftDescription: String = String()
    var imageURL: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblNFTName.text = nftName
        lblDescription.text = nftDescription
        ivNFT.sd_setImage(with: URL(string: imageURL))
        
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
