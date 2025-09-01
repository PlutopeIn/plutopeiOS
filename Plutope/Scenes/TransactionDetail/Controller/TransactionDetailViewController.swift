//
//  TransactionDetailViewController.swift
//  Plutope
//
//  Created by Priyanka on 18/06/23.
//
import UIKit
import SafariServices
import SDWebImage
class TransactionDetailViewController: UIViewController {
    
    @IBOutlet weak var ivCoin: UIImageView!
    @IBOutlet weak var stackViewAmountinFiat: UIStackView!
    @IBOutlet weak var lblCoinPrice: UILabel!
   
    @IBOutlet weak var ivEqualSign: UIImageView!
    @IBOutlet weak var lblCoinAmount: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnMoreDetail: UIButton!
   
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDateText: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblStatusText: UILabel!
    @IBOutlet weak var lblReceipt: UILabel!
    @IBOutlet weak var lblReceiptText: UILabel!
    @IBOutlet weak var lblNonce: UILabel!
    @IBOutlet weak var lblNonceText: UILabel!
    @IBOutlet weak var lblNetworkFee: UILabel!
    @IBOutlet weak var lblNetworkFeeText: UILabel!
    
    var arrTransactionNewData: TransactionHistoryResult?
    lazy var viewModel: TransactionDetailViewModel = {
        TransactionDetailViewModel { _ ,message in
         
            DGProgressView.shared.hideLoader()
        }
    }()
    
    var transactionDetail: [TransactionDetails]?
    var coinDetail: Token?
    var txId: String? = ""
    var isSwap = false
    var isToContract :Bool? = false
    var priceSsymbol = ""
    var price = ""
    var headerTitle = ""
    var type = ""
    fileprivate func uiSetUp() {
        stackViewAmountinFiat.isHidden = false
        lblCoinAmount.isHidden = false
        lblCoinAmount.font = AppFont.violetRegular(30).value
        lblCoinPrice.font = AppFont.violetRegular(24).value
        lblDateText.font = AppFont.violetRegular(14).value
        lblDate.font = AppFont.violetRegular(14).value
        lblStatusText.font = AppFont.violetRegular(14).value
        lblStatus.font = AppFont.violetRegular(14).value
        lblReceiptText.font = AppFont.violetRegular(14).value
        lblReceipt.font = AppFont.violetRegular(14).value
        lblNetworkFeeText.font = AppFont.violetRegular(14).value
        lblNetworkFee.font = AppFont.violetRegular(14).value
        lblNonceText.font = AppFont.violetRegular(14).value
        lblNonce.font = AppFont.violetRegular(14).value
        btnMoreDetail.titleLabel?.font = AppFont.violetRegular(24).value
        
        self.lblDateText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.date, comment: "")
        self.lblStatusText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.status, comment: "")
        self.lblNonceText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.nonce, comment: "")
        self.lblNetworkFeeText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.networkfee, comment: "")
        self.lblReceiptText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.recipient, comment: "")
        self.btnMoreDetail.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.moredetails, comment: ""), for: .normal)
        if let coinDetail = self.coinDetail {
            if coinDetail.symbol?.lowercased() == "usdc.e" {
                coinDetail.symbol = "usdt"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var header = headerTitle
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: header,btnRightImage: UIImage.share,btnRightAction: {
            HapticFeedback.generate(.light)
            // Create a URL to share
            var urlToShare : String {
                switch self.coinDetail?.chain {
                case .binanceSmartChain :
                    return "https://bscscan.com/tx/\(self.txId ?? "")"
                case .ethereum :
                    return "https://etherscan.io/tx/\(self.txId ?? "")"
                case .oKC :
                    return "https://www.okx.com/explorer/oktc/tx/\(self.txId ?? "")"
                case .polygon :
                    return "https://polygonscan.com/tx/\(self.txId ?? "")"
                case .none:
                    return ""
                case .bitcoin:
                    return "https://btcscan.org/tx/\(self.txId ?? "")"
                case .opMainnet:
                    return "https://optimistic.etherscan.io/address/\(self.txId ?? "")"
                case .arbitrum:
                    return "https://arbiscan.io/tx/\(self.txId ?? "")"
                case .avalanche:
                    return "https://subnets.avax.network/c-chain/tx/\(self.txId ?? "")"
                case .base:
                    return "https://basescan.org/tx/\(self.txId ?? "")"
//                case .tron:
//                    return  "https://www.oklink.com/trx/tx/\(self.transactionDetail?.first?.txid ?? "")"
//                case .solana:
//                    return "https://www.oklink.com/sol/tx/\(self.transactionDetail?.first?.txid ?? "")"
                }
            }

            if let url = URL(string: urlToShare) {
                
                // Create an array of items to share (in this case, just the URL)
                let items: [Any] = [url]
                
                // Create an activity view controller
                let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
                
                // Present the activity view controller
                self.present(activityViewController, animated: true, completion: nil)
            }
        })
       
        uiSetUp()
        
        setTransactionDetail()
    }
    
    // setDetails of transaction
    private func setTransactionDetail() {

        let logoURI = coinDetail?.logoURI ?? ""
        if coinDetail?.tokenId == "PLT".lowercased() {
           
            if logoURI == "" {
                ivCoin.sd_setImage(with: URL(string: "https://plutope.app/api/images/applogo.png"))
            } else {
                ivCoin.sd_setImage(with: URL(string: logoURI))
            }
        } else {
            if logoURI == "" {
                ivCoin.sd_setImage(with: URL(string: logoURI))
            } else {
                ivCoin.sd_setImage(with: URL(string: logoURI))
            }
        }
        
        if arrTransactionNewData?.value != "multicall" {
            setTransactionStatus(status: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.completed, comment: ""), color: UIColor.c099817)
        } else {
            setTransactionStatus(status: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.fail, comment: ""), color: .red)
        }
        lblNonce.text = arrTransactionNewData?.nonce
        if let isoDateString = arrTransactionNewData?.timestamp {
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = isoFormatter.date(from: isoDateString) {
                lblDate.text = date.timeIntervalSince1970.getReadableDate() ?? ""
            } else {
                lblDate.text = ""
            }
        } else {
            lblDate.text = ""
        }
        setTokenTransferDetails(firstTransaction: arrTransactionNewData)
        var estimateGasValue = ""
        if let gas = Decimal(string: arrTransactionNewData?.transactionFee ?? "") {
            let totalCost = gas
            print("Total cost: \(totalCost)")
            
            
            let estimateGasValue = WalletData.shared.formatDecimalString("\(totalCost)", decimalPlaces: 12)
            if coinDetail?.address == "" {
                let priceString = coinDetail?.price ?? ""
                let priceDecimal = Decimal(string: priceString) ?? 0
                let costDecimal = totalCost

                let gasPrice = costDecimal * priceDecimal
                let estimateValue = WalletData.shared.formatDecimalString("\(gasPrice)", decimalPlaces: 3)
                lblNetworkFee.text = "\(estimateGasValue) \(self.coinDetail?.symbol ?? "") (\(WalletData.shared.primaryCurrency?.sign ?? "")\(estimateValue))"
                DGProgressView.shared.hideLoader()
            } else {
                var allCoin = DatabaseHelper.shared.retrieveData("Token") as? [Token]
                allCoin = allCoin?.filter { $0.address == "" && $0.type == coinDetail?.type && $0.symbol == self.coinDetail?.chain?.symbol ?? "" }
                
                let priceString = allCoin?.first?.price ?? ""
                let priceDecimal = Decimal(string: priceString) ?? 0
                let costDecimal = totalCost
                let gasPrice = costDecimal * priceDecimal
                let estimateValue = WalletData.shared.formatDecimalString("\(gasPrice)", decimalPlaces: 3)
                lblNetworkFee.text = "\(estimateGasValue) \(self.coinDetail?.symbol ?? "") (\(WalletData.shared.primaryCurrency?.sign ?? "")\(estimateValue))"
                DGProgressView.shared.hideLoader()
            }
        } else {
            print("Invalid number format")
        }
    }
    
  
    
    private func setTransactionStatus(status: String, color: UIColor) {
        lblStatus.text = status
        lblStatus.textColor = color
    }
    
    private func setTokenTransferDetails(firstTransaction: TransactionHistoryResult?) {
        print("priceSsymbol",priceSsymbol)
        print("price",price)
        setAmountLabel(text: "\(self.price)", color: UIColor.label)
    
        if firstTransaction?.fromAddress == coinDetail?.chain?.walletAddress?.lowercased() {
            lblReceipt.text = firstTransaction?.toAddress ?? ""
        } else {
            lblReceipt.text = firstTransaction?.fromAddress ?? ""
        }
    }
    

    private func setAmountLabel(text: String, color: UIColor) {
        print("setAmountLabel")
        lblCoinAmount.textColor = color
        lblCoinPrice.text = ""

        let symbol = coinDetail?.symbol ?? ""
        let convertedValueString = text.replacingOccurrences(of: " \(symbol)", with: "")
        
        // Handle signs explicitly
        let isNegative = convertedValueString.contains("-")
        
        // Remove `+` and `-` for calculation
        let cleanValueString = convertedValueString.replacingOccurrences(of: "+", with: "")
                                                    .replacingOccurrences(of: "-", with: "")
        
        if let coinPrice = Double(coinDetail?.price ?? ""),
           let convertedValue = Double(cleanValueString) {
            
            if convertedValue != 0.0 {
                let price = coinPrice * convertedValue
                let estimateValue = WalletData.shared.formatDecimalString("\(price)", decimalPlaces: 7)
                
                lblCoinPrice.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(estimateValue)"
                lblCoinAmount.text = text
                print("lblCoinAmount", lblCoinAmount.text ?? "")
                ivEqualSign.isHidden = false
            } else {
                lblCoinPrice.text = ""
                lblCoinAmount.text = "0.00 \(symbol)"
                print("lblCoinAmount", "0.00 \(symbol)")
                ivEqualSign.isHidden = true
            }
        }
    }

    
    @IBAction func actionViewMore(_ sender: Any) {
        HapticFeedback.generate(.light)
        var urlToOpen : String {
            switch coinDetail?.chain {
            case .binanceSmartChain :
                return "https://bscscan.com/tx/\(self.txId ?? "")"
            case .ethereum :
                return "https://etherscan.io/tx/\(self.txId ?? "")"
            case .oKC :
                return "https://www.okx.com/explorer/oktc/tx/\(self.txId ?? "")"
            case .polygon :
                return "https://polygonscan.com/tx/\(self.txId ?? "")"
            case .none:
                return ""
            case .bitcoin:
                return "https://btcscan.org/tx/\(self.txId ?? "")"
            case .opMainnet:
                return "https://optimistic.etherscan.io/address/\(self.txId ?? "")"
            case .arbitrum:
                return "https://arbiscan.io/tx/ \(self.txId ?? "")"
            case .avalanche:
                return "https://subnets.avax.network/c-chain/block/\(self.txId ?? "")"
            case .base:
                return "https://basescan.org/tx/\(self.txId ?? "")"
//            case .tron:
//                return  "https://www.oklink.com/trx/tx/\(self.txId ?? "")"
//            case .solana:
//                return "https://www.oklink.com/sol/tx/\(self.txId ?? "")"
            }
        }
        if let url = URL(string: urlToOpen) {
            let safariViewController = SFSafariViewController(url: url)
            let navigationController = UINavigationController(rootViewController: safariViewController)
            navigationController.setNavigationBarHidden(true, animated: false)
            present(navigationController, animated: true, completion: nil)
        }
    }
}

// MARK: APIS
//extension TransactionDetailViewController {
//    private func getTransactionDetail(_ txid: String) {
//        DGProgressView.shared.showLoader(to: self.view)
//        viewModel.getTransactionDetail(coinDetail?.chain?.chainName ?? "", txid) { detail, status, _ in
//            if status {
//                self.transactionDetail = detail
//                self.setTransactionDetail()
//                /// setSwapDetail
//                self.setSwapDetail()
//                
//            }
//        }
//    }
//}
