//
//  CardDashBoardViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 22/05/24.
//

import UIKit

struct CardImageList {
    var image : UIImage?
}

protocol BackToRootDelegate : AnyObject {
    func backktoRootScreen()
}
// swiftlint:disable type_body_length
class CardDashBoardViewController: UIViewController {
    @IBOutlet weak var lblDigitalAssetsTitle: UILabel!
    @IBOutlet weak var btnShowBalance: UIButton!
    @IBOutlet weak var stackToken: UIStackView!
    @IBOutlet weak var lblVirtualCard: UILabel!
    @IBOutlet weak var stackCard: UIStackView!
    @IBOutlet weak var lblChnageTitle: UILabel!
    
    @IBOutlet weak var lblChangeValue: UILabel!
    @IBOutlet weak var viewSlider: UIView!
    @IBOutlet weak var viewAddNewProduct: UIView!
    @IBOutlet weak var stackHeader: UIStackView!
    @IBOutlet weak var btnOrderCard: UIButton!
    @IBOutlet weak var tbvCardHeight: NSLayoutConstraint!
    @IBOutlet weak var tbvwalletdHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var clvSlider: UICollectionView!
    @IBOutlet weak var snakePageControl: SnakePageControl!
    @IBOutlet weak var tbvDashboard: UITableView!
    
    @IBOutlet weak var ivBack: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var ivNext: UIImageView!
    @IBOutlet weak var lblCardCount: UILabel!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var lblBalance: UILabel!
    
    @IBOutlet weak var lblCardType: UILabel!
    @IBOutlet weak var lblCardOrderMsg: UILabel!
    @IBOutlet weak var ivCard: UIImageView!
    @IBOutlet weak var orderCardView: UIView!
    
    @IBOutlet weak var lblSeeAll: UILabel!
    @IBOutlet weak var tbvWallet: UITableView!
    @IBOutlet weak var lblActionNeededTitle: UILabel!
    @IBOutlet weak var lblCardTitle: UILabel!
    
    @IBOutlet weak var lblWalletCount: UILabel!
    @IBOutlet weak var btnAddNewProduct: GradientButton!
    @IBOutlet weak var viewActionNeeded: UIView!
    @IBOutlet weak var btnStartKyc: GradientButton!
    
    @IBOutlet weak var clvActions: UICollectionView!
    @IBOutlet weak var imgHistory: UIImageView!
    @IBOutlet weak var lblTotalBalance: UILabel!
    
    let refreshControl = UIRefreshControl()
    weak var delegate : BackToRootDelegate?
    var primaryWallet: Wallets?
    var arrProfileList : CardUserDataList?
    
    var transctionsValueArr  = [DashboardTrnsactions]()

    var cardPrice = ""
    var currencyValue = ""
    var totalCurrencyValue = ""
    var arrCardList : [Card] = []
    var additionalStatuses:[String] = []
    var cardRequestId = 0
    var isStatus = ""
    var cardType = ""
    var kycStatus = ""
    var arrWalletList : [Wallet] = []
    var arrFiatList : Fiat?
    var isRefesh = false
    var arrDashbordImges : [String] = []
    var timer: Timer?
    var currentIndex = 0
    var changeValues = ""
    var changePercentage = ""
    var lastChange: Double?
        var lastChangePercent: Double?
        var lastUpdate: Date?
    var currencyData = DatabaseHelper.shared.retrieveData("Currencies") as? [Currencies]
    lazy var cardUserProfileViewModel: CardUserProfileViewModel = {
        CardUserProfileViewModel { _ ,_ in
        }
    }()
    lazy var myCardViewModel: MyCardViewModel = {
        MyCardViewModel { _ ,_ in
        }
    }()
    lazy var myCardDetailsViewModel: MyCardDetailsViewModel = {
        MyCardDetailsViewModel { _ ,_ in
        }
    }()
    lazy var myTokenViewModel: MyTokenViewModel = {
        MyTokenViewModel { _ ,_ in
        }
    }()
    lazy var updateViewModel: UpdateKYCViewModel = {
        UpdateKYCViewModel { _ ,_ in
        }
    }()
    let server = serverTypes
    var publicKey = ""
    var privetKey = ""
    var totalBalanceValue: String = ""
    var isRevealed = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = false
    
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name("RefreshCardDashBoard"), object: nil)
        /// Table Register
        tableRegister()
        /// dynamic slider
        /*getDashboardImages()*/
        /*startTimer()*/
        tbvDashboard.isHidden = true
        loadNibs()
        // Configure the refresh control
                refreshControl.addTarget(self, action: #selector(refreshDataList), for: .valueChanged)
                   
                // Add the refresh control to the scroll view
                scrollView.refreshControl = refreshControl
        uiSetUp()
        
        fetchAllData()
        stackHeader.addTapGesture {
            HapticFeedback.generate(.light)
            let cardProfileVC =  CardUsersProfileViewController()
            cardProfileVC.hidesBottomBarWhenPushed = true
             self.navigationController?.pushViewController(cardProfileVC, animated: true)
        }
        imgHistory.addTapGesture {
            HapticFeedback.generate(.light)
            let cardHistroryVC = AllTranscationHistryViewController()
            cardHistroryVC.hidesBottomBarWhenPushed = true
             self.navigationController?.pushViewController(cardHistroryVC, animated: true)
        }
        ivBack.addTapGesture {
            HapticFeedback.generate(.light)
//            self.tabBarController?.selectedIndex = 1
            let cardProfileVC =  CardUsersProfileViewController()
            cardProfileVC.hidesBottomBarWhenPushed = true
             self.navigationController?.pushViewController(cardProfileVC, animated: true)
        }
        lblSeeAll.addTapGesture {
            HapticFeedback.generate(.light)
            let walletVC = MyTokenViewController()
            walletVC.isFrom = "dashboard"
            walletVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(walletVC, animated: true)
        }
        snakePageControl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
//        transctionsValueArr =  [DashboardTrnsactions(image: UIImage.receive, name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addFunds, comment: "")),DashboardTrnsactions(image: UIImage.send, name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send, comment: "")),DashboardTrnsactions(image: UIImage.swap, name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.exchange, comment: ""))]
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let itemCount = clvSlider.numberOfItems(inSection: 0)
        if itemCount > 0 {
            let targetIndexPath = IndexPath(item: 1, section: 0)
            if targetIndexPath.item < itemCount {
                clvSlider.scrollToItem(at: targetIndexPath, at: .centeredVertically, animated: false)
            }
        }
        clvActions.reloadData()
        clvActions.restore()
    }
    func fetchAllData() {
        let dispatchGroup = DispatchGroup()

        // Show loader before starting API calls
//        DGProgressView.shared.showLoader(to: view)
        tbvWallet.showLoader()
        dispatchGroup.enter()
        getCardNew {
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        getProfileDataNew {
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        getWalletTokensNew {
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            // Hide loader when all API calls are completed
            DGProgressView.shared.hideLoader()
            self.tbvWallet.hideLoader()
            print("All API calls completed")
        }
    }

    @objc func refreshDataList() {
            // Simulate a network request or data update
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                // End refreshing
                self.isRefesh = true
                /// live
                self.getCardNew { }
                self.getWalletTokensNew {  }
                self.refreshControl.endRefreshing()
            }
        }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            /*startTimer()*/
        
        NotificationCenter.default.addObserver(forName: Notification.Name("LanguageDidChange"), object: nil, queue: .main) { (notification) in
            self.clvSlider.reloadData()
            self.clvSlider.restore()
            self.tbvWallet.reloadData()
            self.tbvWallet.restore()
            self.uiSetUp()
        }
      
//        self.getKycStatusNew()
         fetchAllData()
        
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            /*stopTimer()*/
        }

        /*func startTimer() {
            timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextItem), userInfo: nil, repeats: true)
        }

        func stopTimer() {
            timer?.invalidate()
            timer = nil
        }*/

    @objc func scrollToNextItem() {
           let nextIndex = (currentIndex + 1) % arrDashbordImges.count
           let indexPath = IndexPath(item: nextIndex, section: 0)

           if nextIndex == 0 {
               // Scroll from last to first without animation
               clvSlider.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
           } else {
               clvSlider.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
           }

           currentIndex = nextIndex
       }
    
    @objc func refreshData() {
        /// live
        self.getCardNew { }
        self.getWalletTokensNew { }
            print("Refresh data called")
        
      }
    deinit {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("RefreshCardDashBoard"), object: nil)
        }
    /// Table Register
    func tableRegister() {
        tbvWallet.delegate = self
        tbvWallet.dataSource = self
        tbvWallet.register(MyTokenTableViewCell.nib, forCellReuseIdentifier: MyTokenTableViewCell.reuseIdentifier)

    }
     func loadNibs() {
        /// Register collectionView
    clvSlider.register(ProductDetailsViewCell.nib, forCellWithReuseIdentifier: ProductDetailsViewCell.reuseIdentifier)
         clvSlider.delegate = self
         clvSlider.dataSource = self
         
         clvActions.register(WalletDashboardCell.nib, forCellWithReuseIdentifier: WalletDashboardCell.reuseIdentifier)
         clvActions.delegate = self
         clvActions.dataSource = self
    }

    /*func getDashboardImages() {
        myCardViewModel.getDashboardImagesAPI { status, msg, data in
            
            if status == 1 {
                self.arrDashbordImges = data ?? []
//                self.snakePageControl.pageCount = self.arrCardList.count
                self.snakePageControl.pageCount = self.arrDashbordImges.count
                DispatchQueue.main.async {
                    if self.arrDashbordImges.isEmpty {
                        self.viewSlider.isHidden = true
                    } else {
                        self.viewSlider.isHidden = false
                        self.clvSlider.reloadData()
                        self.clvSlider.restore()
                    }
                }
            } else {
                self.showToast(message: msg, font: AppFont.regular(15).value)
            }
        }
    }*/

    func update(responseData: Fiat?) -> String? {
           let now = Date()
           var displayString: String?
        var changeValue = 0.0
        var changePercentage = 0.0
           if let lastChange = lastChange, let lastChangePercent = lastChangePercent, let lastUpdate = lastUpdate {
             
               if let change = responseData?.change {
                   let changeValues: Double = {
                       switch change {
                       case .int(let value):
                           return Double(value)
                       case .double(let value):
                           return value
                       }
                   }()
                   self.changeValues = "\(changeValues)"
                   
               } else {
                   self.changeValues = "0"
               }

               if let changePercent = responseData?.changePercent {
                   let changePercentValue: Double = {
                       switch changePercent {
                       case .int(let value):
                           return Double(value)
                       case .double(let value):
                           return value
                       }
                   }()
                   self.changePercentage = "\(changePercentValue)"
                   
               } else {
                   self.changePercentage = "0"
               }
               
               changeValue = Double(self.changeValues) ?? 0.0
               changePercentage = Double(self.changePercentage) ?? 0.0
               if changeValue != lastChange || changePercentage != lastChangePercent {
                   let timeInterval = now.timeIntervalSince(lastUpdate)
                   
                   let secondsInMinute: TimeInterval = 60
                   let secondsInHour: TimeInterval = 3600
                   let secondsInDay: TimeInterval = 86400

                   if timeInterval < secondsInMinute {
                       displayString = "\(Int(timeInterval))s"
                   } else if timeInterval < secondsInHour {
                       let minutes = Int(timeInterval / secondsInMinute)
                       displayString = "\(minutes)M"
                   } else if timeInterval < secondsInDay {
                       let hours = Int(timeInterval / secondsInHour)
                       displayString = "\(hours)H"
                   } else {
                       let days = Int(timeInterval / secondsInDay)
                       displayString = "\(days)D"
                   }
                   
                   // Update the last values and timestamp
                   self.lastChange = changeValue
                   self.lastChangePercent = changePercentage
                   self.lastUpdate = now
               }
           } else {
               // First time initialization
               self.lastChange = changeValue
               self.lastChangePercent = changePercentage
               self.lastUpdate = now
           }

           return displayString
       }
    func presentActionNeedPopUpViewController(withStatus status: String) {
        let vcToPresent = ActionNeedPopUpViewController()
        vcToPresent.cardRequestId = self.arrCardList.first?.cardRequestID ?? 0
        vcToPresent.arrCardList = self.arrCardList.first
        vcToPresent.delegate = self
        vcToPresent.isStatus = status
        self.navigationController?.present(vcToPresent, animated: true)
    }

    @IBAction func btnOrderCardAction(_ sender: Any) {
        HapticFeedback.generate(.light)
//        if self.kycStatus == "APPROVED" {
            let vcToPresent = AddNewCardViewController()
            vcToPresent.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vcToPresent, animated: true)
//        } else {
//
//            if !additionalStatuses.contains("KYC") {
//                let vcToPresent = ActionNeedPopUpViewController()
//                vcToPresent.cardRequestId = self.arrCardList.first?.cardRequestID ?? 0
//                vcToPresent.arrCardList = self.arrCardList.first
//                vcToPresent.delegate = self
//                vcToPresent.isStatus = "Kyc"
//                vcToPresent.isFrom = "order"
//                self.navigationController?.present(vcToPresent, animated: true)
//            }
//        }
    }
    @IBAction func btnAddNewProductAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        let vcToPresent = AddNewCardActionPopup()
        self.navigationController?.present(vcToPresent, animated: true)
    }
    
    @IBAction func btnShowHideBalanceAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        isRevealed.toggle()
        if isRevealed {
            lblBalance.text = self.totalBalanceValue
            let closeEyeImage = UIImage.eye
            let templateImage = closeEyeImage.withRenderingMode(.alwaysTemplate)
            btnShowBalance.setImage(templateImage, for: .normal)
            btnShowBalance.tintColor = UIColor.white
        } else {
            lblBalance.text = String(repeating: "*", count: self.totalBalanceValue.count)
            let openEyeImage = UIImage.closeEye
            let templateImage = openEyeImage.withRenderingMode(.alwaysTemplate)
            btnShowBalance.setImage(templateImage, for: .normal)
            btnShowBalance.tintColor = UIColor.white
            
//            btnShowPassword.setImage(UIImage.eye, for: .normal)
        }
    }
}
// swiftlint:enable type_body_length
extension CardDashBoardViewController : ActionNeedPopUpDelegate {
    func goToNextScreen(isStatus: String) {
        if isStatus == "Kyc" {
            let updateKYCVC = UpdateKYCViewController()
            updateKYCVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(updateKYCVC, animated: false)
        } else if isStatus == "addresss" {
            let updateAddressVC = UpdateCardRequestAddressViewController()
            updateAddressVC.isFrom = "dashboard"
            updateAddressVC.hidesBottomBarWhenPushed = true
            updateAddressVC.cardRequestId = self.arrCardList.first?.cardRequestID
            self.navigationController?.pushViewController(updateAddressVC, animated: false)
           
        } else if isStatus == "additionalInfo" {
            let updateAddressVC = AdditionalPersonalInfoViewController()
            updateAddressVC.isFrom = "dashboard"
            updateAddressVC.hidesBottomBarWhenPushed = true
            updateAddressVC.cardRequestId = self.arrCardList.first?.cardRequestID ?? 0
            self.navigationController?.pushViewController(updateAddressVC, animated: false)
        } else if isStatus == "paid" {
            let cardPaymentVC = CardPaymentViewControllerNew()
            cardPaymentVC.hidesBottomBarWhenPushed = true
            cardPaymentVC.cardRequestId = self.arrCardList.first?.cardRequestID ?? 0
            cardPaymentVC.cardType = self.cardType
//            cardPaymentVC.address = self.address
            self.navigationController?.pushViewController(cardPaymentVC, animated: false)
        } else if isStatus == "support" {
            
        } else if isStatus == "inProgress" {
            
        }
   
    }
    func refreshCards() {
        /// live
        self.getCardNew {   }
    }
}
