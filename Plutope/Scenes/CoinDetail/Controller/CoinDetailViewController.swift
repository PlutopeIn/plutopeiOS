//
//  CoinDetailViewController.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit

class CoinDetailViewController: UIViewController, Reusable {
    
    @IBOutlet weak var segmentHeight: NSLayoutConstraint!
    @IBOutlet weak var lblBuy: UILabel!
    @IBOutlet weak var lblCoinNetwork: DesignableLabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet weak var btnReceive: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var viewNoTransaction: UIView!
    @IBOutlet weak var lblPer: UILabel!
    @IBOutlet weak var ivCoinImage: UIImageView!
    @IBOutlet weak var lblCoinBal: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tbvTransactions: UITableView!
    @IBOutlet weak var constantTbvHeight: NSLayoutConstraint!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTransactions: UILabel!
    @IBOutlet weak var lblSend: UILabel!
    @IBOutlet weak var lblReceive: UILabel!
 //   @IBOutlet weak var lblBuy: UILabel!
    @IBOutlet weak var lblMore: UILabel!
    @IBOutlet weak var lblNoTransactions: UILabel!
  //  @IBOutlet weak var lblSend: UILabel!
   // @IBOutlet weak var lblReceive: UILabel!
  //  @IBOutlet weak var lblMore: UILabel!
    var isFetchingData = false
    var isInternalFetchingData = false
    var coinDetail: Token?
    var isToContract  = false
    var url: String?
    @IBOutlet weak var segmentTransactions: CustomSegmentedControl!
    var transactionHistory: [TransactionHistory] = []
    weak var refreshWalletDelegate: RefreshDataDelegate?
    var arrTransactionData: [TransactionResult] = []
    var arrInternalTransactionData: [TransactionResult] = []
    weak var updatebalDelegate: RefreshDataDelegate?
    var isCustomAdded: Bool = false
    var selectedSegment = String()
    lazy var viewModel: TransactionHistoryViewModel = {
        TransactionHistoryViewModel { _ , _ in
            // self.showToast(message: message, font: .systemFont(ofSize: 15))
            self.viewNoTransaction.isHidden = false
            self.tbvTransactions.isHidden = true
            DGProgressView.shared.hideLoader()
        }
    }()
    lazy var buyViewModel: CoinMinPriceViewModel = {
        CoinMinPriceViewModel { status, message in
            if status == false {
              //  self.showToast(message: message, font: .systemFont(ofSize: 15))
            }
        }
    }()
    lazy var registerUserViewModel: RegisterUserViewModel = {
        RegisterUserViewModel { _ ,message in
         //   self.showToast(message: message, font: .systemFont(ofSize: 15))
            // self.btnDone.HideLoader()
        }
    }()
    var page = 1
    var pageInternal = 1
    
    fileprivate func uiSetUp() {
        self.lblTransactions.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.transactions, comment: "")
        self.lblSend.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send, comment: "")
        self.lblReceive.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.receive, comment: "")
        self.lblBuy.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.buy, comment: "")
        self.lblMore.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.more, comment: "")
        self.lblNoTransactions.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.notransactionsyet, comment: "")
        self.segmentTransactions.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.transaction, comment: ""), forSegmentAt: 0)
        self.segmentTransactions.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.internalText, comment: ""), forSegmentAt: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedSegment = "Transaction"
        /// Navigation Header
        defineHeader(headerView: headerView, titleText:  coinDetail?.name ?? "", btnBackHidden: false, popToRoot: true, btnRightImage: UIImage.icGraph) {
            let viewToNavigate = CoinGraphViewController()
            viewToNavigate.coinDetail = self.coinDetail
            self.navigationController?.pushViewController(viewToNavigate, animated: true)
        } btnBackAction: {
            if self.isCustomAdded {
                if let rootVC = self.navigationController?.viewControllers.first(where: {$0 is WalletDashboardViewController}) as? WalletDashboardViewController {
                    self.refreshWalletDelegate = rootVC
                } else {
                    self.refreshWalletDelegate = nil
                }
                self.refreshWalletDelegate?.refreshData()
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
        /// UI Set up
        uiSetUp()
        
        /// Table Register
        tableRegister()
        
        /// call setcoin detail
        setCoinDetail()
        
        // segment
        segmentSetup()
       
        /// getTransactionHistory
        
        // set segment for only main chains 
//        if coinDetail?.symbol == "MATIC" && coinDetail?.type == "POLYGON" {
        if coinDetail?.address == "" {
            segmentTransactions.isHidden = false
            segmentHeight.constant = 40
        } else {
            segmentTransactions.isHidden = true
            segmentHeight.constant = 0
        }
        if DataStore.networkEnv == .mainnet {
            self.getTransactionHistory("\(self.page)")
//            self.getInternalTransactionHistory("\(self.pageInternal)")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    /// setcoin detail
    fileprivate func setCoinDetail() {
        
        if let coinDetail = self.coinDetail {
            if coinDetail.symbol == "usdc.e" {
                coinDetail.symbol = "usdt"
            }
        }
     //   print(coinDetail?.symbol?.lowercased() == "usdc.e")
        if let balanceString = coinDetail?.balance, let balance = Double(balanceString) {
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 7

            if let formattedBalance = formatter.string(from: NSNumber(value: balance)) {
                lblCoinBal.text = formattedBalance + " \(coinDetail?.symbol ?? "")"
            }
        } else {
            lblCoinBal.text = "0 \(coinDetail?.symbol ?? "")"
        }
        lblCoinNetwork.text = coinDetail?.type
        /// Price impact set up with color
        if Double(coinDetail?.lastPriceChangeImpact ?? "") ?? 0.0 >= 0 {
            self.lblPer.text = "+\(coinDetail?.lastPriceChangeImpact ?? "")%"
            self.lblPer.textColor = UIColor.c099817
        } else {
            self.lblPer.text = "\(coinDetail?.lastPriceChangeImpact ?? "")%"
            self.lblPer.textColor = .red
        }
        lblPrice.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(coinDetail?.price ?? "")"
        /// Set coin image
        if let logoURI = coinDetail?.logoURI, !logoURI.isEmpty {
            ivCoinImage.sd_setImage(with: URL(string: logoURI))
        } else {
            ivCoinImage.image = coinDetail?.chain?.chainDefaultImage
        }
        if coinDetail?.isUserAdded ?? false {
            btnBuy.isHidden = true
            lblBuy.isHidden = true
            btnMore.isHidden = true
            lblMore.isHidden = true
            lblPrice.text = ""
            lblPer.text = ""
        } else {
            btnBuy.isHidden = false
            btnMore.isHidden = false
            lblMore.isHidden = false
            lblBuy.isHidden = false
        }
    }
    
    @IBAction func actionSendCoin(_ sender: Any) {
        
//        if(coinDetail?.chain?.coinType == CoinType.bitcoin) {
//            self.showToast(message: ToastMessages.btcComingSoon, font: UIFont.systemFont(ofSize: 15))
//        } else {
            let viewToNavigate = SendCoinViewController()
            viewToNavigate.coinDetail = self.coinDetail
            viewToNavigate.refreshWalletDelegate = self
            viewToNavigate.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewToNavigate, animated: true)
      //  }
    }
    
    @IBAction func actionBuy(_ sender: Any) {
        let coinData = self.coinDetail
        let buyCoinVC = BuyCoinViewController()
        //        var minimumAmount: Double = Double()
        //        buyViewModel.apiGetCoinPrice(coinData?.symbol?.lowercased() ?? "") { data, status, error in
        //            if status {
        //                switch coinData?.type {
        //                case "ERC20" :
        //                    let minAmount = round(data?.minimumBuyAmount?["0"] ?? 0).rounded(.up)
        //                    buyCoinVC.lblPrice.text = "\(minAmount)"
        //                    minimumAmount = minAmount
        //                case "BEP20":
        //                    let minAmount = round(data?.minimumBuyAmount?["1"] ?? 0).rounded(.up)
        //                    buyCoinVC.lblPrice.text = "\(minAmount)"
        //                    minimumAmount = minAmount
        //                default: break
        //
        //                }
        //                buyCoinVC.minimumAmount = minimumAmount
        //                buyCoinVC.lblCoinQuantity.text = "\(((Double(buyCoinVC.lblPrice.text ?? "0") ?? 0.0) / (Double(coinData?.price ?? "") ?? 0.0)).rounded(toPlaces: 5)) \(coinData?.symbol ?? "")"
        //                if (Double(buyCoinVC.lblPrice.text ?? "0") ?? 0.0) > 0 {
        //                    buyCoinVC.btnNext.alpha = 1
        //                    buyCoinVC.btnNext.isUserInteractionEnabled = true
        //                } else {
        //                    buyCoinVC.btnNext.alpha = 0.5
        //                    buyCoinVC.btnNext.isUserInteractionEnabled = false
        //                }
        //
        //            } else {
        //                print(error)
        //            }
        //        }
        
        buyCoinVC.headerTitle = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.buy, comment: "")) \(coinData?.symbol ?? "")"
        buyCoinVC.coinDetail = coinData
        //        buyCoinVC.minimumAmount = minimumAmount
        self.navigationController?.pushViewController(buyCoinVC, animated: true)
    }
    
    @IBAction func actionSwapCoin(_ sender: Any) {
        if isIPAD {
            showBottonSheetIniPad()
        } else {
            showBottomSheet()
        }
    }
    
    @IBAction func actionReceiveCoin(_ sender: Any) {
        let viewToNavigate = ReceiveCoinViewController()
        viewToNavigate.coinDetail = self.coinDetail
        viewToNavigate.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewToNavigate, animated: true)
    }
    
    /// Table Register
    func tableRegister() {
        tbvTransactions.delegate = self
        tbvTransactions.dataSource = self
        tbvTransactions.register(TransactionViewCell.nib, forCellReuseIdentifier: TransactionViewCell.reuseIdentifier)
        mainScrollView.delegate = self
    }
    
@IBAction func actionSegment(_ sender: Any) {
        
        if segmentTransactions.selectedSegmentIndex == 0 {
            selectedSegment = "Transaction"
            self.page = 1
            self.getTransactionHistory("\(self.page)")
            tbvTransactions.reloadData()
        } else if segmentTransactions.selectedSegmentIndex == 1 {
            self.pageInternal = 1
           selectedSegment = "Internal"
            self.getInternalTransactionHistory("\(self.pageInternal)")
          
        }
        
    }
    /// Segment Setup
    private func segmentSetup() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.c767691, NSAttributedString.Key.font: AppFont.bold(16).value, NSAttributedString.Key.backgroundColor: UIColor.clear]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: AppFont.bold(16).value]
        segmentTransactions.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        segmentTransactions.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentTransactions.layer.cornerRadius = 50
        segmentTransactions.layer.masksToBounds = true
        segmentTransactions.clipsToBounds = true
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        switch segmentTransactions.selectedSegmentIndex {
        case 0:
            if offsetY > contentHeight - scrollView.frame.height && !isFetchingData {
                // Check if the refresh control is not already refreshing

                self.page += 1
                self.getTransactionHistory("\(self.page)")
            }
        case 1:
            if offsetY > contentHeight - scrollView.frame.height && !isInternalFetchingData {
                // Check if the refresh control is not already refreshing

                self.pageInternal += 1
                self.getInternalTransactionHistory("\(self.pageInternal)")
            }
        default:
            break
        }
        
//        if offsetY > contentHeight - scrollView.frame.height && !isFetchingData {
//            // Check if the refresh control is not already refreshing
//
//            self.page += 1
//            self.getTransactionHistory("\(self.page)")
//        }
        
    }
    
    func findDuplicatesUsingCountedSet(in array: [String]) -> [String] {
        let countedSet = NSCountedSet(array: array)
        var duplicates = [String]()

        for element in countedSet {
//            if countedSet.count(for: element) > 1 {
//                duplicates.append(element as! String)
//            }
            if let element = element as? String, countedSet.count(for: element) > 1 {
                duplicates.append(element)
            }
        }

        return duplicates
    }
    
    // getTransactionHistory
    fileprivate func getTransactionHistory(_ page: String) {
        DGProgressView.shared.showLoader(to: self.view)
        viewModel.apiGetTransactionaHistroy(self.coinDetail!, "\(self.page)") { transactionData, status, _ in
            if status {
                
                self.registerUserViewModel.setWalletActiveAPI(walletAddress: WalletData.shared.myWallet?.address ?? "") { resStatus, message in
                   // if resStatus == 1 {
                        print(message)
                    // }
                }
                if !(transactionData?.isEmpty ?? false) {
                    self.arrTransactionData.removeAll()
                    self.arrTransactionData.append(contentsOf: transactionData ?? [])
                   
                    var txIDToIsSwapMap: [String: Bool] = [:]
                    var uniqueTransactionsByID: [String: TransactionResult] = [:]
                    var uniqueTransactionsByTime: [String: TransactionResult] = [:]

                    for transaction in self.arrTransactionData {
                        if let txID = transaction.txID {
                            // Check if the transaction's txID is unique
                            if !txIDToIsSwapMap.keys.contains(txID) {
                                txIDToIsSwapMap[txID] = transaction.isSwap ?? false
                                uniqueTransactionsByID[txID] = transaction
                            } else {
                                // If a transaction with the same txID already exists, set isSwap to true
                                txIDToIsSwapMap[txID] = true
                            }
                        }

                        if let timeString = transaction.transactionTime {
                                // Store the transaction based on timeString
                                uniqueTransactionsByTime[timeString] = transaction
                            }
                    }
                    // Get unique transactions by time
                    let sortedTransactions = uniqueTransactionsByTime.values.sorted {
                        guard let timeStamp1 = TimeInterval($0.transactionTime ?? ""),
                              let timeStamp2 = TimeInterval($1.transactionTime ?? "") else {
                            return false
                        }
                        return timeStamp1 > timeStamp2
                    }
                    // Store the unique filtered transactions back in self.arrTransactionData
                    self.arrTransactionData = Array(sortedTransactions)
                    
                    // Update the isSwap value in the arrTransactionData array
                    for idx in 0..<self.arrTransactionData.count {
                        if let txID = self.arrTransactionData[idx].txID {
                            self.arrTransactionData[idx].isSwap = txIDToIsSwapMap[txID]
                        }
                    }
                    if self.coinDetail?.address != "" {
                        self.arrTransactionData = self.arrTransactionData.filter({ data in
//                            let result = formattedSymbol == self.arrTransactionData.first?.transactionSymbol?.lowercased()
                           //  if data.methodID == "" && data.transactionSymbol == self.coinDetail?.symbol ?? "" {
                            // chnage tokenContractAddress insted of transactionSymbol in condition
                            
                            if data.methodID == "" && data.tokenContractAddress == self.coinDetail?.address ?? "" {
                                return true
                            } else {
                                return false
                            }
                        })
                    }
                   // print("arrTransactionData",self.arrTransactionData)
                    
                } else {
                    self.isFetchingData = true
                }
                if self.arrTransactionData.count == 0 {
                    self.viewNoTransaction.isHidden = false
                    self.tbvTransactions.isHidden = true
                } else {
                    self.viewNoTransaction.isHidden = true
                    self.tbvTransactions.isHidden = false
                   
                }
               
                self.tbvTransactions.restore()
                self.tbvTransactions.reloadData()
                DGProgressView.shared.hideLoader()
                
            } else {
                self.viewNoTransaction.isHidden = false
                self.tbvTransactions.isHidden = true
                DGProgressView.shared.hideLoader()
                self.isFetchingData = true
            }
        }
    }
    
    // getInternalTransactionHistory
    fileprivate func getInternalTransactionHistory(_ page: String) {
        DGProgressView.shared.showLoader(to: self.view)
        viewModel.apiGetInternalTransactionaHistroy(self.coinDetail!, "\(self.pageInternal)") { transactionData, status, _ in
            if status {
                if !(transactionData?.isEmpty ?? false) {
                    self.arrInternalTransactionData.removeAll()
                    self.arrInternalTransactionData.append(contentsOf: transactionData ?? [])
                   
                    var txIDToIsSwapMap: [String: Bool] = [:]
                    var uniqueTransactionsByID: [String: TransactionResult] = [:]
                    var uniqueTransactionsByTime: [String: TransactionResult] = [:]

                    for transaction in self.arrInternalTransactionData {
                        if let txID = transaction.txID {
                            // Check if the transaction's txID is unique
                            if !txIDToIsSwapMap.keys.contains(txID) {
                                txIDToIsSwapMap[txID] = transaction.isSwap ?? false
                                uniqueTransactionsByID[txID] = transaction
                            } else {
                                // If a transaction with the same txID already exists, set isSwap to true
                                txIDToIsSwapMap[txID] = true
                            }
                        }

                        if let timeString = transaction.transactionTime {
                                // Store the transaction based on timeString
                                uniqueTransactionsByTime[timeString] = transaction
                            }
                    }
                    // Get unique transactions by time
                    let sortedTransactions = uniqueTransactionsByTime.values.sorted {
                        guard let timeStamp1 = TimeInterval($0.transactionTime ?? ""),
                              let timeStamp2 = TimeInterval($1.transactionTime ?? "") else {
                            return false
                        }
                        return timeStamp1 > timeStamp2
                    }
                    // Store the unique filtered transactions back in self.arrInternalTransactionData
                    self.arrInternalTransactionData = Array(sortedTransactions)
                    
                    // Update the isSwap value in the arrTransactionData array
                    for idx in 0..<self.arrInternalTransactionData.count {
                        if let txID = self.arrInternalTransactionData[idx].txID {
                            self.arrInternalTransactionData[idx].isSwap = txIDToIsSwapMap[txID]
                        }
                    }
                    if self.coinDetail?.address != "" {
                        self.arrInternalTransactionData = self.arrInternalTransactionData.filter({ data in
//                            let result = formattedSymbol == self.arrInternalTransactionData.first?.transactionSymbol?.lowercased()
                           //  if data.methodID == "" && data.transactionSymbol == self.coinDetail?.symbol ?? "" {
                            // chnage tokenContractAddress insted of transactionSymbol in condition
                            
                            if data.methodID == "" && data.tokenContractAddress == self.coinDetail?.address ?? "" {
                                return true
                            } else {
                                return false
                            }
                        })
                    }
                   // print("arrInternalTransactionData",self.arrInternalTransactionData)
                    
                } else {
                    self.isInternalFetchingData = true
                   
                }
                if self.arrInternalTransactionData.count == 0 {
                    self.viewNoTransaction.isHidden = false
                    self.tbvTransactions.isHidden = true
                
                } else {
                    self.viewNoTransaction.isHidden = true
                    self.tbvTransactions.isHidden = false
                    // self.tbvTransactions.restore()
//                    self.tbvTransactions.reloadData()
                  
                }
              
                self.tbvTransactions.restore()
                self.tbvTransactions.reloadData()
                DGProgressView.shared.hideLoader()
                
            } else {
               
                self.viewNoTransaction.isHidden = false
                self.tbvTransactions.isHidden = true
                DGProgressView.shared.hideLoader()
                self.isInternalFetchingData = true
            }
        }
    }
}

// MARK: PrimaryWalletDelegate
extension CoinDetailViewController: RefreshDataDelegate {
    func refreshData() {
        if let walletDash = self.navigationController?.viewControllers.first as? WalletDashboardViewController {
            updatebalDelegate = walletDash
            updatebalDelegate?.refreshData()
            self.navigationController?.popViewController(animated: true)
            self.tabBarController?.selectedIndex = 1
        }
    }
}

class CustomPopoverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize the appearance of your custom popover
        view.backgroundColor = UIColor.white

        // Add your action buttons
        let action1Button = UIButton(type: .system)
        action1Button.setTitle("Action 1", for: .normal)
        action1Button.addTarget(self, action: #selector(action1Pressed), for: .touchUpInside)
        view.addSubview(action1Button)

        let action2Button = UIButton(type: .system)
        action2Button.setTitle("Action 2", for: .normal)
        action2Button.addTarget(self, action: #selector(action2Pressed), for: .touchUpInside)
        view.addSubview(action2Button)

        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        view.addSubview(cancelButton)

        // Layout action buttons with constraints
        action1Button.translatesAutoresizingMaskIntoConstraints = false
        action2Button.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            action1Button.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            action1Button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            action1Button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            action1Button.heightAnchor.constraint(equalToConstant: 50),

            action2Button.topAnchor.constraint(equalTo: action1Button.bottomAnchor, constant: 10),
            action2Button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            action2Button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            action2Button.heightAnchor.constraint(equalToConstant: 50),

            cancelButton.topAnchor.constraint(equalTo: action2Button.bottomAnchor, constant: 10),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func action1Pressed() {
        // Handle Action 1
        dismiss(animated: true, completion: nil)
    }

    @objc func action2Pressed() {
        // Handle Action 2
        dismiss(animated: true, completion: nil)
    }

    @objc func cancelPressed() {
        // Handle Cancel
        dismiss(animated: true, completion: nil)
    }
    
}
