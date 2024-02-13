//
//  TransactionDetailViewController.swift
//  Plutope
//
//  Created by Priyanka on 18/06/23.
//
import UIKit
import SafariServices

class TransactionDetailViewController: UIViewController {
    
    @IBOutlet weak var stackViewAmountinFiat: UIStackView!
    @IBOutlet weak var lblCoinPrice: UILabel!
    @IBOutlet weak var lblGetCoinType: UILabel!
    @IBOutlet weak var lblGetCoinAmount: UILabel!
    @IBOutlet weak var ivGetCoin: UIImageView!
    @IBOutlet weak var lblPayCoinType: UILabel!
    @IBOutlet weak var lblPayCoinAmount: UILabel!
    @IBOutlet weak var ivPayCoin: UIImageView!
    @IBOutlet weak var ivEqualSign: UIImageView!
    @IBOutlet weak var lblCoinAmount: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnMoreDetail: UIButton!
    @IBOutlet weak var stackViewSwap: UIStackView!
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
    
    lazy var viewModel: TransactionDetailViewModel = {
        TransactionDetailViewModel { _ ,message in
            self.showToast(message: message, font: .systemFont(ofSize: 15))
            DGProgressView.shared.hideLoader()
        }
    }()
    
    var transactionDetail: [TransactionDetails]?
    var coinDetail: Token?
    var txId: String? = ""
    var isSwap = false
    override func viewDidLoad() {
        super.viewDidLoad()
        stackViewSwap.isHidden = true
        stackViewAmountinFiat.isHidden = true
        lblCoinAmount.isHidden = true
        
        self.lblDateText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.date, comment: "")
        self.lblStatusText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.status, comment: "")
        self.lblNonceText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.nonce, comment: "")
        self.lblNetworkFeeText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.networkfee, comment: "")
        self.lblReceiptText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.recipient, comment: "")
        self.btnMoreDetail.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.moredetails, comment: ""), for: .normal)
        
        /// getTransactionDetail
        getTransactionDetail(txId ?? "")
        
    }
    
    // setDetails of transaction
    private func setTransactionDetail() {
        guard let firstTransaction = transactionDetail?.first else {
            return
        }
        
        if firstTransaction.state == "success" {
            setTransactionStatus(status: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.completed, comment: ""), color: UIColor.c099817)
        } else {
            setTransactionStatus(status: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.fail, comment: ""), color: .red)
        }
        let unixTimeStamp: Double = Double(TimeInterval(firstTransaction.transactionTime ?? "") ?? 0) / 1000.0
        lblDate.text = unixTimeStamp.formatDate("MMM dd yyyy, hh:mm a")
        lblNonce.text = firstTransaction.nonce ?? ""
        if firstTransaction.tokenTransferDetails?.count == 0 {
            if coinDetail?.address != "" {
                setTokenTransferDetails(firstTransaction: firstTransaction)
            } else {
                setCoinAmountDetails(firstTransaction: firstTransaction)
            }
        } else {
            if (firstTransaction.tokenTransferDetails?.count ?? 0) > 1 {
                if isSwap {
                    setSwapAmountDetail(firstTransaction: firstTransaction)
                } else {
                    setTokenTransferDetails(firstTransaction: firstTransaction)
                }
            //    setSwapAmountDetail(firstTransaction: firstTransaction)
                
            } else {
                setTokenTransferDetails(firstTransaction: firstTransaction)
            }
        }
        
        let convertedGasValue = firstTransaction.txfee ?? ""
        if coinDetail?.address == "" {
            let gasPrice = ((Double(convertedGasValue) ?? 0.0) * (Double(coinDetail?.price ?? "") ?? 0.0)) / 1
            
            let estimateValue = WalletData.shared.formatDecimalString("\(gasPrice)", decimalPlaces: 2)
            lblNetworkFee.text = "\(convertedGasValue) \(firstTransaction.transactionSymbol ?? "") (\(WalletData.shared.primaryCurrency?.sign ?? "")\(estimateValue))"
            DGProgressView.shared.hideLoader()
        } else {
            var allCoin = DatabaseHelper.shared.retrieveData("Token") as? [Token]
            allCoin = allCoin?.filter{ $0.address == "" && $0.type == coinDetail?.type && $0.symbol == self.coinDetail?.chain?.symbol ?? "" }
            let gasPrice = ((Double(convertedGasValue) ?? 0.0) * (Double(allCoin?.first?.price ?? "") ?? 0.0))
            
            let estimateValue = WalletData.shared.formatDecimalString("\(gasPrice)", decimalPlaces: 2)
            lblNetworkFee.text = "\(convertedGasValue) \(firstTransaction.transactionSymbol ?? "") (\(WalletData.shared.primaryCurrency?.sign ?? "")\(estimateValue))"
            DGProgressView.shared.hideLoader()
        }
    }
    
    // SwapDetail set
    func setSwapDetail() {
        guard let firstTransaction = transactionDetail?.first else {
            return
        }
        if (firstTransaction.tokenTransferDetails?.count ?? 0) > 1 {
            if isSwap {
                stackViewSwap.isHidden = false
                stackViewAmountinFiat.isHidden = true
                lblCoinAmount.isHidden = true
            } else {
                stackViewSwap.isHidden = true
                stackViewAmountinFiat.isHidden = false
                lblCoinAmount.isHidden = false
            }
//            stackViewSwap.isHidden = false
//            stackViewAmountinFiat.isHidden = true
//            lblCoinAmount.isHidden = true
            
        } else {
            stackViewSwap.isHidden = true
            stackViewAmountinFiat.isHidden = false
            lblCoinAmount.isHidden = false
            
        }
        var header = ""
       
        if(firstTransaction.tokenTransferDetails?.count ?? 0) > 1 {
            if isSwap {
               header =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swap, comment: "")
            } else {
                header = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.transfer, comment: "")
            }
            
        } else {
            header =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.transfer, comment: "")
        }
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: header,btnRightImage: UIImage.share,btnRightAction: {
            // Create a URL to share
            var urlToShare : String {
                switch self.coinDetail?.chain {
                case .binanceSmartChain :
                    return "https://bscscan.com/tx/\(self.transactionDetail?.first?.txid ?? "")"
                case .ethereum :
                    return "https://etherscan.io/tx/\(self.transactionDetail?.first?.txid ?? "")"
                case .oKC :
                    return "https://www.okx.com/explorer/oktc/tx/\(self.transactionDetail?.first?.txid ?? "")"
                case .polygon :
                    return "https://polygonscan.com/tx/\(self.transactionDetail?.first?.txid ?? "")"
                case .none:
                    return ""
                case .bitcoin:
                    return "https://btcscan.org/tx/\(self.transactionDetail?.first?.txid ?? "")"
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
    }
    
    private func setTransactionStatus(status: String, color: UIColor) {
        lblStatus.text = status
        lblStatus.textColor = color
    }
    
    private func setTokenTransferDetails(firstTransaction: TransactionDetails) {
        
        guard let tokenTransferDetails = firstTransaction.tokenTransferDetails?.first else {
            return
        }
        
        let amount = WalletData.shared.formatDecimalString("\(tokenTransferDetails.amount ?? "")", decimalPlaces: 8)
      //  let amount = String(format: "%.8f", (Double(tokenTransferDetails.amount ?? "") ?? 0.0))
        if tokenTransferDetails.from == coinDetail?.chain?.walletAddress?.lowercased() {
            lblReceipt.text = tokenTransferDetails.to ?? ""
            setAmountLabel(text: "-\(amount) \(coinDetail?.symbol ?? "")", color: .white)
        } else {
            lblReceipt.text = tokenTransferDetails.from ?? ""
            setAmountLabel(text: "+\(amount) \(coinDetail?.symbol ?? "")", color: UIColor.white)
        }
    }
    
    private func setCoinAmountDetails(firstTransaction: TransactionDetails) {
        let amount = WalletData.shared.formatDecimalString("\(firstTransaction.amount ?? "")", decimalPlaces: 8)
       // let amount = String(format: "%.8f",(Double(firstTransaction.amount ?? "") ?? 0.0))
        if firstTransaction.inputDetails?.first?.inputHash == coinDetail?.chain?.walletAddress?.lowercased() {
            lblReceipt.text = firstTransaction.outputDetails?.first?.outputHash ?? ""
            setAmountLabel(text: "-\(amount) \(coinDetail?.symbol ?? "")", color: .white)
        } else {
            lblReceipt.text = firstTransaction.inputDetails?.first?.inputHash ?? ""
            setAmountLabel(text: "+\(amount) \(coinDetail?.symbol ?? "")", color: UIColor.white)
        }
    }
    
    private func setSwapAmountDetail(firstTransaction: TransactionDetails) {
        
        let transactions: [TokenTransferDetail] = firstTransaction.tokenTransferDetails ?? []
        var payTokenDetails: TokenTransferDetail?
        var getTokenDetails: TokenTransferDetail?
                for tokenDetails in transactions {
                    print("From:",tokenDetails.from ?? "")
                    print("Wallet:",coinDetail?.chain?.walletAddress ?? "")
                    if tokenDetails.from?.lowercased() == coinDetail?.chain?.walletAddress?.lowercased() {
                        lblPayCoinAmount.text = "\(tokenDetails.amount ?? "") \(tokenDetails.symbol ?? "")"
                        payTokenDetails = tokenDetails // Store the selected tokenDetails
                    }
                   // print("TO:",tokenDetails.to)
                    if tokenDetails.to?.lowercased() == coinDetail?.chain?.walletAddress?.lowercased() {
                        lblGetCoinAmount.text = "\(tokenDetails.amount ?? "") \(tokenDetails.symbol ?? "")"
                        getTokenDetails = tokenDetails // Store the selected tokenDetails
                    }
                    
                    if let allToken = DatabaseHelper.shared.retrieveData("Token") as? [Token] {
                        if let payToken = allToken.first(where: { $0.address?.lowercased() == payTokenDetails?.tokenContractAddress?.lowercased() }) {
                            ivPayCoin.sd_setImage(with: URL(string: payToken.logoURI ?? ""))
                            lblPayCoinType.text = payToken.type ?? ""
                        }
                        if let getToken = allToken.first(where: { $0.address?.lowercased() == getTokenDetails?.tokenContractAddress?.lowercased() }) {
                            ivGetCoin.sd_setImage(with: URL(string: getToken.logoURI ?? ""))
                            lblGetCoinType.text = getToken.type ?? ""
                        }
                    }
                }
        
        lblReceipt.text = coinDetail?.chain?.walletAddress?.lowercased() ?? ""
    }
    
    private func setAmountLabel(text: String, color: UIColor) {
        
        lblCoinAmount.textColor = color
        lblCoinPrice.text = ""
        let convertedValueString = text.replacingOccurrences(of: " \(coinDetail?.symbol ?? "")", with: "")
        if let coinPrice = Double(coinDetail?.price ?? ""),
           let convertedValue = Double(convertedValueString.replacingOccurrences(of: "-", with: "")) {
            
            if convertedValue != 0.0 {
                
                let price = (coinPrice * convertedValue)
                let estimateValue = WalletData.shared.formatDecimalString("\(price)", decimalPlaces: 3)
                lblCoinPrice.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(estimateValue)"
                lblCoinAmount.text = text
                ivEqualSign.isHidden = false
            } else {
                lblCoinPrice.text = ""
                lblCoinAmount.text = "0.00 \(coinDetail?.symbol ?? "")"
                ivEqualSign.isHidden = true
            }
        }
    }
    
    @IBAction func actionViewMore(_ sender: Any) {
        var urlToOpen : String {
            switch coinDetail?.chain {
            case .binanceSmartChain :
                return "https://bscscan.com/tx/\(transactionDetail?.first?.txid ?? "")"
            case .ethereum :
                return "https://etherscan.io/tx/\(transactionDetail?.first?.txid ?? "")"
            case .oKC :
                return "https://www.okx.com/explorer/oktc/tx/\(transactionDetail?.first?.txid ?? "")"
            case .polygon :
                return "https://polygonscan.com/tx/\(transactionDetail?.first?.txid ?? "")"
            case .none:
                return ""
            case .bitcoin:
                return "https://btcscan.org/tx/\(self.transactionDetail?.first?.txid ?? "")"
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
extension TransactionDetailViewController {
    private func getTransactionDetail(_ txid: String) {
        DGProgressView.shared.showLoader(to: self.view)
        viewModel.getTransactionDetail(coinDetail?.chain?.chainName ?? "", txid) { detail, status, _ in
            if status {
                self.transactionDetail = detail
                self.setTransactionDetail()
                /// setSwapDetail
                self.setSwapDetail()
                
            }
        }
    }
}
