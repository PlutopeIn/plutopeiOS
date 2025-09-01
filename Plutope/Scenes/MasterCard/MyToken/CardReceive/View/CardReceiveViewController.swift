//
//  CardReceiveViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 14/06/24.
//

import UIKit
import CoreGraphics
import CoreImage
import SDWebImage
import ShapeQRCode

class CardReceiveViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnSelectCoin: UIButton!
    @IBOutlet weak var lblType1: DesignableLabel!
    @IBOutlet weak var ivCoin: UIImageView!
    @IBOutlet weak var txtBalance: LoadingTextField!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var ivQrCode: UIImageView!
    @IBOutlet weak var lblWalletAddress: UILabel!
    @IBOutlet weak var btnCopy: UIButton!
    @IBOutlet weak var btnShare: GradientButton!
    
    @IBOutlet weak var viewQRCode: UIView!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnWalletAddress: GradientButton!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var stackCreateAdrees: UIStackView!
    var selectedTokenArray = [String]()
    var arrWalletList : [Wallet] = []
    var walletArr : Wallet?
    var newWallets:[CreateWalletDataList] = []
    var walletAddress = ""
    var currenccy = ""
    lazy var myTokenViewModel: MyTokenViewModel = {
        MyTokenViewModel { _ ,_ in
        }
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.getWalletTokens()
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.receive, comment: ""))
        self.lblType1.text = walletArr?.currency
        self.ivCoin.sd_setImage(with: URL(string: "\(walletArr?.iconUrl ?? "")"), placeholderImage: UIImage.icBank)
        
        let balance = WalletData.shared.formatDecimalString(walletArr?.balanceString ?? "", decimalPlaces: 6)
        self.txtBalance.text = balance
        self.currenccy = walletArr?.currency ?? ""
        var network = ""
//        self.lblType.text = "\(walletArr?.currency ?? "") Network"
        print("walletArr",walletArr?.network)
        
        if walletArr?.network == "" || walletArr?.network == nil {
            network = walletArr?.currency ?? ""
        } else {
            network = walletArr?.network ?? ""
        }
        self.lblType.text = "\(network) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.network, comment: ""))"
        btnShare.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.share, comment: ""), for: .normal)
        btnWalletAddress.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.createWalletAddress, comment: ""), for: .normal)
        lblMsg.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.createWalletAddressMsg, comment: "")
        
        let QRimage = generateQRCode(from: self.walletAddress, centerImage: UIImage.icQRLogo)
        self.ivQrCode.image = QRimage
        lblWalletAddress.text = self.walletAddress
        txtBalance.font = AppFont.regular(15.7).value
        
        lblType1.font = AppFont.regular(16).value
        
//        lblTitle.font = AppFont.violetRegular(25).value
        
        
    }
    
    @IBAction func btnCopyAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        UIPasteboard.general.string = self.lblWalletAddress.text ?? ""
        self.showToast(message: "\(StringConstants.copied): \(self.lblWalletAddress.text ?? "")", font: AppFont.regular(15).value)
    }
    func getWalletTokens() {
        myTokenViewModel.getTokenAPINew { status, data ,fiat ,msg in
            if status == 1 {
                DispatchQueue.main.async {
                    self.arrWalletList = data ?? []
                }
            } else {
            }
            
        }
    }
    @IBAction func btnShareAction(_ sender: Any) {
        
        shareQRCode()
        HapticFeedback.generate(.light)
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
        let address = self.lblWalletAddress.text ?? ""
        /// Create an array of the objects you want to share (in this case, only the image)
        let shareItems: [Any] = [image,address]
        
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
    @IBAction func btnSelectCoinAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        txtBalance.text = ""
        let tokenListVC = MyTokenViewController()
        
        tokenListVC.isFrom = "receive"
        tokenListVC.delegate = self
        self.navigationController?.present(tokenListVC, animated: true)
    }
    @IBAction func btnWalletAddressAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        self.createWallet(currencyValue: self.currenccy)
    }
}
extension CardReceiveViewController : TopupWalletDelegate {
    func selectedToken(tokenName: String, tokenimage: String?, tokenbalance: String, tokenAmount: String, tokenCurruncy: String, tokenArr: Wallet?, currency: String,isFromToken1: String?) {
        DispatchQueue.main.async {
            
            self.lblType1.text = tokenName
            self.ivCoin.sd_setImage(with: URL(string: "\(tokenimage ?? "")"), placeholderImage: UIImage.icBank)
            
            let balance = WalletData.shared.formatDecimalString(tokenbalance, decimalPlaces: 6)
            self.txtBalance.text = "\(balance)"
            
            var network = ""
    //        self.lblType.text = "\(walletArr?.currency ?? "") Network"
            if tokenArr?.network == "" || tokenArr?.network == nil {
                network = tokenArr?.currency ?? ""
            } else {
                network = tokenArr?.network ?? ""
            }
            self.lblType.text = "\(network) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.network, comment: ""))"
            self.btnWalletAddress.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.createWalletAddress, comment: ""), for: .normal)
            self.lblMsg.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.createWalletAddressMsg, comment: "")
            if tokenArr?.address == "" {
                self.stackCreateAdrees.isHidden = false
                self.viewAddress.isHidden = true
                if LocalizationSystem.sharedInstance.getLanguage() == "hi" {
                    self.lblTitle.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.createWalletAddresstitle2, comment: "")) \(tokenName) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.createWalletAddresstitle1, comment: ""))"
                } else {
                    self.lblTitle.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.createWalletAddresstitle1, comment: "")) \(tokenName) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.createWalletAddresstitle2, comment: ""))"
                }
                
               
                self.currenccy = tokenName
                
            } else {
                self.stackCreateAdrees.isHidden = true
                self.viewAddress.isHidden = false
                let QRimage = self.generateQRCode(from: tokenArr?.address ?? "", centerImage: UIImage.icQRLogo)
                self.ivQrCode.image = QRimage
                self.lblWalletAddress.text = tokenArr?.address ?? ""
            }
                
        }
    }
    
}
extension CardReceiveViewController {
    
    func createWallet(currencyValue:String) {
         // let currency = currencyValue {
        if !selectedTokenArray.contains(currencyValue) {
            selectedTokenArray.append(currencyValue)
        }
   // selectedTokenArray.append(currencyValue)
        
        DGProgressView.shared.showLoader(to: view)
        myTokenViewModel.createWalletAPI(currencies: self.selectedTokenArray) { status, msg, data in
            DispatchQueue.main.async {
            if status == 1 {
                DGProgressView.shared.hideLoader()
                self.showToast(message: "Wallet address created", font: AppFont.regular(15).value)
                self.newWallets = data ?? []
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.stackCreateAdrees.isHidden = true
                    self.viewAddress.isHidden = false
                    let QRimage = self.generateQRCode(from: self.newWallets.first?.address ?? "", centerImage: UIImage.icQRLogo)
                    self.ivQrCode.image = QRimage
                    self.lblWalletAddress.text = self.newWallets.first?.address
                }
              //  self.navigationController?.popViewController(animated: true)
            } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: "Something went wrong! Please Try again", font: AppFont.regular(15).value)
            }
            }
        }
    }
}
