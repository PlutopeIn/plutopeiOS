//
//  ReceiveCoinViewController.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//

import UIKit
import CoreGraphics
import CoreImage
import ShapeQRCode

class ReceiveCoinViewController: UIViewController, Reusable {
    
    @IBOutlet weak var viewQRCode: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var ivQrCode: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblSetAmount: UILabel!
    @IBOutlet weak var qrCodeHeight: NSLayoutConstraint!
    var amount = ""
    var coinDetail: Token?
    var walletType = ""
    var prefixValue = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Navigation Header
        
        defineHeader(headerView: headerView, titleText: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.receive, comment: "")) \(coinDetail?.symbol ?? "")")
        lblAddress.font = AppFont.regular(14).value
        lblSetAmount.font = AppFont.regular(12).value
        var address:String = ""
        if(coinDetail?.chain?.coinType == CoinType.bitcoin) {
            address = WalletData.shared.getPublicWalletAddress(coinType: .bitcoin) ?? ""
        
        } else {
            address = WalletData.shared.getPublicWalletAddress(coinType: .ethereum) ?? ""
        }
        print("Address = ",address)
        if coinDetail?.address == "" && coinDetail?.symbol == "ETH" {
            prefixValue = "ethereum"
        } else if coinDetail?.address == "" && coinDetail?.symbol == "POL" {
            prefixValue = "polygon"
        } else if coinDetail?.address == "" && coinDetail?.symbol == "BNB" {
            prefixValue = "smartchain"
        } else if coinDetail?.address == "" && coinDetail?.symbol == "BTC" {
            prefixValue = "bitcoin"
        } else if coinDetail?.address == "" && coinDetail?.symbol == "ARB" {
            prefixValue = "ethereum"
        } else if coinDetail?.address == "" && coinDetail?.symbol == "AVAX" {
            prefixValue = "ethereum"
        }
        
//        let qrString = "\(prefixValue):\(self.coinDetail?.chain?.walletAddress ?? "")"
        let qrString = "\(self.coinDetail?.chain?.walletAddress ?? "")"
        let QRimage = generateQRCode(from: qrString, centerImage: UIImage.icQRLogo)
        self.ivQrCode.image = QRimage
        lblAddress.text = coinDetail?.chain?.walletAddress ?? ""
        
    }
    
    /// generateQRCode
    func generateQRCode(from inputString: String,centerImage: UIImage) -> UIImage? {
      
        // create the image that should be contained in the qr code
        let img = try? ShapeQRCode.Image(withUIImage: centerImage, width: 0.3, height: 0.3, transparencyDetectionEnabled: false)
       // the actual struct that encapsulates the QR code data
        let qrCode = ShapeQRCode(withText: inputString, andImage: img, shape: .square, moduleSpacingPercent: 2, color: .black, errorCorrectionLevel: .high)
        
        // Render the qr code represented by the qr as an UIImage with 500px width/height
        let renderedQRImage = qrCode.image(withLength: self.ivQrCode.bounds.width)
        return renderedQRImage
        
    }
    
    fileprivate func shareQRCode() {
        /// Create a UIImage object with the image you want to share
         let image = self.viewQRCode.takeScreenshot()
        
        /// Create an array of the objects you want to share (in this case, only the image)
        let shareItems: [Any] = [image]
        
        /// Create the activity view controller
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        
        /// Exclude some activity types if needed
        activityViewController.excludedActivityTypes = [
            .airDrop,
            .addToReadingList
        ]
        
        /// Check if the device is iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            /// If the device is iPad, present the activity view controller as a popover
            activityViewController.popoverPresentationController?.sourceView = view
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            activityViewController.popoverPresentationController?.permittedArrowDirections = []
        }
        
        /// Present the activity view controller
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func shareAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        shareQRCode()
    }
    
    @IBAction func setAmountAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        let addFiatAmountVC = AddFiatAmountViewController()
        addFiatAmountVC.coinDetail = self.coinDetail
        addFiatAmountVC.delegate = self
        addFiatAmountVC.modalTransitionStyle = .crossDissolve
        addFiatAmountVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(addFiatAmountVC, animated: true)
//        self.navigationController?.pushViewController(addFiatAmountVC, animated: true)
        
    }
    
    @IBAction func btnCopyAddressAction(_ sender: Any) {
        HapticFeedback.generate(.light)
       UIPasteboard.general.string = coinDetail?.chain?.walletAddress ?? ""
        
//        UIPasteboard.general.string = "\(self.coinDetail?.chain?.walletAddress ?? "")?amount=\(self.amount)"
        self.showToast(message: "\(StringConstants.copied): \(coinDetail?.chain?.walletAddress ?? "")", font: AppFont.regular(15).value)
    }
    
}
extension ReceiveCoinViewController : AddFiatAmountDelegate {
    func addFiatAmount(tokenAmount: String, type: String, value:String,walletType:String) {
        print(tokenAmount)
        var qrString = ""
        self.walletType = walletType
        let primaryCurrency = WalletData.shared.primaryCurrency?.sign  ?? ""
        let amount = Double(tokenAmount) ?? 0.0
        let symbol = self.coinDetail?.symbol ?? ""
        self.amount = tokenAmount
        let price = Double(self.coinDetail?.price ?? "0") ?? 0.0
        // Calculate the converted coin balance
        let convertedBalance = amount * price
        
     //   if self.walletType == "other" {
        
        if coinDetail?.address == "" && coinDetail?.symbol == "ETH" {
            prefixValue = "ethereum:"
        } else if coinDetail?.address == "" && coinDetail?.symbol == "POL" {
            prefixValue = "polygon:"
        } else if coinDetail?.address == "" && coinDetail?.symbol == "BNB" {
            prefixValue = "smartchain:"
        } else if coinDetail?.address == "" && coinDetail?.symbol == "BTC" {
            prefixValue = "bitcoin:"
        } else if coinDetail?.address == "" && coinDetail?.symbol == "ARB" {
            prefixValue = "ethereum:"
        } else if coinDetail?.address == "" && coinDetail?.symbol == "AVAX" {
            prefixValue = "ethereum:"
        } else if coinDetail?.address == "" && coinDetail?.symbol == "OP" {
            prefixValue = "ethereum:"
        } else if coinDetail?.address == "" && coinDetail?.symbol == "BASE" {
            prefixValue = "ethereum:"
        } else {
            prefixValue = ""
        }
        
            if type == "currency" {
                let balanceValue = value
                self.lblSetAmount.text = "\(tokenAmount) \(symbol) ≈  \(primaryCurrency)\(balanceValue)"
                qrString = "\(prefixValue)\(self.coinDetail?.chain?.walletAddress ?? "")?amount=\(tokenAmount)"
                
            } else {
                let balanceValue = WalletData.shared.formatDecimalString("\(convertedBalance)", decimalPlaces: 5)
                self.lblSetAmount.text = "\(tokenAmount) \(symbol) ≈  \(primaryCurrency)\(balanceValue)"
                qrString = "\(prefixValue)\(self.coinDetail?.chain?.walletAddress ?? "")?amount=\(tokenAmount)"
            }
            let qrImage = self.generateQRCode(from: qrString, centerImage: UIImage.icQRLogo)
            DispatchQueue.main.async {
                self.ivQrCode.image = qrImage
            }
        //}
//        else {
//            if type == "currency" {
//                let balanceValue = value
//                self.lblSetAmount.text = "\(tokenAmount) \(symbol) ≈  \(primaryCurrency)\(balanceValue)"
//
//                if (coinDetail?.type == "POLYGON") {
//                    qrString = "ethereum:\(self.coinDetail?.chain?.walletAddress ?? "")@137?value=\(tokenAmount)"
//                    print(qrString)
//                } else if (coinDetail?.type == "ERC20") {
//                    qrString = "ethereum:\(self.coinDetail?.chain?.walletAddress ?? "")@1?value\(tokenAmount)"
//                    print(qrString)
//                } else if (coinDetail?.type == "BEP20") {
//                    qrString = "ethereum:\(self.coinDetail?.chain?.walletAddress ?? "")@56?value=\(tokenAmount)"
//                    print(qrString)
//                } else {
//
//                }
//
//            } else {
//                let balanceValue = WalletData.shared.formatDecimalString("\(convertedBalance)", decimalPlaces: 5)
//                self.lblSetAmount.text = "\(tokenAmount) \(symbol) ≈  \(primaryCurrency)\(balanceValue)"
//                if (coinDetail?.type == "POLYGON") {
//                    qrString = "ethereum:\(self.coinDetail?.chain?.walletAddress ?? "")@137?value=\(tokenAmount)"
//                    print(qrString)
//                } else if (coinDetail?.type == "ERC20") {
//                    qrString = "ethereum:\(self.coinDetail?.chain?.walletAddress ?? "")@1?value\(tokenAmount)"
//                    print(qrString)
//                } else if (coinDetail?.type == "BEP20") {
//                    qrString = "ethereum:\(self.coinDetail?.chain?.walletAddress ?? "")@56?value=\(tokenAmount)"
//                    print(qrString)
//                } else {
//
//                }
//            }
//            let qrImage = self.generateQRCode(from: qrString, centerImage: UIImage.icQRLogo)
//            DispatchQueue.main.async {
//                self.ivQrCode.image = qrImage
//            }
//        }
    }
}
