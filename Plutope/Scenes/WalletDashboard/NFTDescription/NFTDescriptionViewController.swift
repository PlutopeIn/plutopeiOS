//
//  NFTDescriptionViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 29/06/23.
//

import UIKit
import SDWebImage
import SafariServices

class NFTDescriptionViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var lblContractAddressTitle: UILabel!
    @IBOutlet weak var lblContractAddress: UILabel!
    @IBOutlet weak var lblTokenStandardTitle: UILabel!
    @IBOutlet weak var lblTokenStandard: UILabel!
    @IBOutlet weak var lblNetworkTitle: UILabel!
    @IBOutlet weak var lblNetwork: UILabel!
    
    @IBOutlet weak var lblTokenIdTitle: UILabel!
    @IBOutlet weak var lblNFTName: UILabel!
    @IBOutlet weak var ivNFT: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblTokenId: UILabel!
    var nftName: String = String()
    var nftDescription: String = String()
    var imageURL: String = String()
    var arrNftDataNew: NFTDataNewElement?
    
     func uiSetUp() {
        lblNFTName.text = arrNftDataNew?.metadata?.name
        lblDescription.text = arrNftDataNew?.metadata?.description
        let imageUrlString = arrNftDataNew?.metadata?.image ?? ""
        ivNFT.sd_setImage(with: URL(string: imageUrlString))
         if let chain = Chain.from(chainIdHex: arrNftDataNew?.chain ?? "") {
             print("Matched chain: \(chain.name)")  // Output: "BNB Smart Chain"
             lblNetwork.text = "\(chain.name)(\(arrNftDataNew?.chain ?? ""))"
         }
       
        lblTokenStandard.text = arrNftDataNew?.contractType
        lblTokenId.text = arrNftDataNew?.tokenID
        lblContractAddress.setCenteredEllipsisText(arrNftDataNew?.tokenAddress ?? "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(arrNftDataNew)
        defineHeader(headerView: headerView, titleText: "",btnRightImage: UIImage.moreImg) {
            print("rightAction")
            HapticFeedback.generate(.light)
            self.showShareSendAlert(from: self, title: "", message: "") {
                let chain = Chain.from(chainIdHex: self.arrNftDataNew?.chain ?? "")
                   var chainUrl = ""
                if chain?.name == "Polygon" {
                        chainUrl = "https://polygonscan.com/address/\(self.arrNftDataNew?.tokenAddress ?? "")"
                    } else if chain?.name == "Ethereum" {
                        chainUrl = "https://etherscan.io/address/\(self.arrNftDataNew?.tokenAddress ?? "")"
                    } else if chain?.name == "BNB Smart Chain" {
                        chainUrl = "https://bscscan.com/address/\(self.arrNftDataNew?.tokenAddress ?? "")"
                    } else if chain?.name == "OKschain" {
                        chainUrl = "https://www.okx.com/explorer/oktc/address/\(self.arrNftDataNew?.tokenAddress ?? "")"
                    } else if chain?.name == "Bitcoin" {
                        chainUrl = "https://btcscan.org/address/\(self.arrNftDataNew?.tokenAddress ?? "")"
                    } else if chain?.name == "OP Mainnet" {
                        chainUrl = "https://optimistic.etherscan.io/address/\(self.arrNftDataNew?.tokenAddress ?? "")"
                    } else if chain?.name == "Arbitrum One" {
                        chainUrl = "https://arbiscan.io/address/\(self.arrNftDataNew?.tokenAddress ?? "")"
                    } else if chain?.name == "Avalanche C-Chain" {
                        chainUrl = "https://subnets.avax.network/c-chain/address/\(self.arrNftDataNew?.tokenAddress ?? "")"
                    } else if chain?.name == "Base" {
                        chainUrl = "https://basescan.org/address/\(self.arrNftDataNew?.tokenAddress ?? "")"
                    }
                        guard let url = URL(string: chainUrl) else { return }
                        let safariVC = SFSafariViewController(url: url)
                        safariVC.modalPresentationStyle = .overFullScreen
                        self.present(safariVC, animated: true)
                // Handle send logic here
            }
        }
        uiSetUp()
    }
    
    
    func showShareSendAlert(from viewController: UIViewController, title: String, message: String, viewonExplorerHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        HapticFeedback.generate(.light)
//        alert.addAction(UIAlertAction(title: "Share", style: .default, handler: { _ in
//            shareHandler()
//        }))

        alert.addAction(UIAlertAction(title: "View on explorer", style: .default, handler: { _ in
            viewonExplorerHandler()
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        viewController.present(alert, animated: true)
    }

    @IBAction func actionCancel(_ sender: Any) {
        HapticFeedback.generate(.light)
        self.dismiss(animated: true)
    }
}
