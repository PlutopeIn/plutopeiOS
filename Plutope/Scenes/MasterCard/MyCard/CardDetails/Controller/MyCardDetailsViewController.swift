//
//  MyCardDetailsViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 20/05/24.
//

import UIKit
import Lottie
import Security
import Foundation

struct MenuOptionsList {
    let title: String
    let image: UIImage
}

class MyCardDetailsViewController: UIViewController ,Reusable {

    @IBOutlet weak var ivBackView: UIImageView!
    @IBOutlet weak var imgFrontVew: UIImageView!
    @IBOutlet weak var tbvHeight: NSLayoutConstraint!
    @IBOutlet weak var tbvHisotry: UITableView!
    @IBOutlet weak var lotteView: LottieAnimationView!
    @IBOutlet weak var overvewView: UIView!
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var vwCardFrontSide: UIView!
    @IBOutlet weak var lblCardUserName: UILabel!
    @IBOutlet weak var btnCardFlipFront: UIButton!
    @IBOutlet weak var lblCardBalance: UILabel!
    @IBOutlet weak var btnShowHideBalance: UIButton!
    @IBOutlet weak var vwCardBackSide: UIView!
    @IBOutlet weak var lblCardSRNumber: UILabel!
    @IBOutlet weak var btnCardFlipBack: UIButton!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblCVVNumber: UILabel!
    @IBOutlet weak var lblValidityText: UILabel!
    @IBOutlet weak var lblExpiryDate: UILabel!
    @IBOutlet weak var lblCardHelplineNumber: UILabel!
    @IBOutlet weak var clvMenuOptions: UICollectionView!
    @IBOutlet weak var btnSeeAll: UIButton!
    @IBOutlet weak var btnUpdateCardAdress: GradientButton!
    
    @IBOutlet weak var lblSeeAll: NSLayoutConstraint!
    @IBOutlet weak var lblTransactionHistiryTitle: UILabel!
    @IBOutlet weak var lblBalanceTitle: UILabel!
    var arrCardList : Card?
    var cardRequestId : Int?
    var currencyData = DatabaseHelper.shared.retrieveData("Currencies") as? [Currencies]
    var currencyValue = ""
    var balanceValue = ""
    var cardNumber = ""
    var code = ""
    var decryptedCardNo  = ""
    var decryptedCardCvv = ""
    var decryptedCardExpiry = ""
    var decryptedCardName  = ""
    var publicKey = ""
    var privetKey = ""
    var isFreeze = false
    var isFrom = ""
    var isFromPinNumber = false
    var isFromExpiry = false
    var status = ""
    var sign = ""
    var selectedSegment = String()
    var arrCardHistory : [CardHistoryListNew] = []
    var transactionsByDate = [CardHistorySection]()
   
    var isFlipped = false
    
    lazy var myCardViewModel: MyCardViewModel = {
        MyCardViewModel { _ ,_ in
        }
    }()
    lazy var myCardDetailsViewModel: MyCardDetailsViewModel = {
        MyCardDetailsViewModel { _ ,_ in
        }
    }()
    var arrMenuOptions: [MenuOptionsList] = []
   
    fileprivate func uiSetup() {
        if self.arrCardList?.cardDesignID == "BLUE" {
            self.vwCardFrontSide.backgroundColor = UIColor.clear
            self.vwCardBackSide.backgroundColor = UIColor.clear
            self.ivBackView.image = UIImage.ivBlueCard
            self.imgFrontVew.image = UIImage.ivBlueCard
        } else if self.arrCardList?.cardDesignID == "ORANGE" {
            self.vwCardFrontSide.backgroundColor = UIColor.cffa500
            self.vwCardBackSide.backgroundColor = UIColor.cffa500
        } else if self.arrCardList?.cardDesignID == "BLACK" {
            self.vwCardFrontSide.backgroundColor = UIColor.black
            self.vwCardBackSide.backgroundColor = UIColor.black
        } else if self.arrCardList?.cardDesignID == "GOLD" {
            self.vwCardFrontSide.backgroundColor = UIColor.clear
            self.vwCardBackSide.backgroundColor = UIColor.clear
            self.ivBackView.image = UIImage.ivGoldCard
            self.imgFrontVew.image = UIImage.ivGoldCard
        } else if self.arrCardList?.cardDesignID == "PURPLE" {
            self.vwCardFrontSide.backgroundColor = UIColor.c800080
            self.vwCardBackSide.backgroundColor = UIColor.c800080
        }
        
        self.lblExpiryDate.text = "**/**"
        self.lblCVVNumber.text = "****"
        self.lblCardUserName.text = arrCardList?.cardholderName ?? ""
        if let price = arrCardList?.balance?.value {
            let priceValue: Double = {
                switch price {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            self.balanceValue = "\(priceValue)"
        } else {
            self.balanceValue  = "0"
        }
        
        self.lblCardBalance.text = "\(self.balanceValue.prefix(2) + "****")"
        lotteView.loopMode = .loop
        lotteView.animationSpeed = 1.5
        lotteView.isHidden = true
        
        self.lblCardBalance.font = AppFont.violetRegular(20.70).value
        lblTransactionHistiryTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.transactionHistory, comment: "")
        let titleString = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.seeAll, comment: "")
        let attributedTitle = NSAttributedString(string: titleString)
        btnSeeAll.setAttributedTitle(attributedTitle, for: .normal)

        lblBalanceTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.balance, comment: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cardNumber = self.showLastFourDigits(of: arrCardList?.number ?? "")
        // Navigation header
        self.getCardHistory(cardId: "\(arrCardList?.id ?? 0)", size: 50) {
        }
        defineHeader(headerView: headerView, titleText: "\(arrCardList?.cardType ?? "") \(cardNumber)", btnBackHidden: false)
        /// Table Register
        tableRegister()
        /// Collection Register
        collectionRegister()
        uiSetup()
    }
    /// Table Register
    func tableRegister() {
        tbvHisotry.delegate = self
        tbvHisotry.dataSource = self
        tbvHisotry.register(CardHistryTbvCell.nib, forCellReuseIdentifier: CardHistryTbvCell.reuseIdentifier)
    }
    /// Collection Register
    func collectionRegister() {
        clvMenuOptions.delegate = self
        clvMenuOptions.dataSource = self
        clvMenuOptions.register(OptionMenuCollectionCell.nib, forCellWithReuseIdentifier: OptionMenuCollectionCell.reuseIdentifier)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrMenuOptions = [
           MenuOptionsList(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.Topup, comment: ""), image: UIImage.icTopUp),
           MenuOptionsList(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.details, comment: ""), image: UIImage.icDetailsHide),
           MenuOptionsList(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.ChangePin, comment: ""), image: UIImage.icChangePin)
       ]
        if arrCardList?.status == "SOFT_BLOCKED" {
            arrMenuOptions.insert(MenuOptionsList(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.UnFreeze, comment: ""), image: UIImage.icFreezeeHide), at: 1)
            isFreeze = true
        } else {
            arrMenuOptions.insert(MenuOptionsList(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.Freeze, comment: ""), image: UIImage.icFreezee), at: 1)
            isFreeze = false
        }
        
        getCardNumber()
//        getCardInfoCode()
    }
    func updateUI() {
//        if isFrom == "cardExpiry" {
//            txtCardExpiry.text =
        DispatchQueue.main.async {
            self.lblExpiryDate.text = self.formatDateString(inputString: self.decryptedCardExpiry)
            self.lblCVVNumber.text = self.decryptedCardCvv
        }
            
//        } else {
//            txtCardPin.text = self.decryptedCardCvv
//            txtCardExpiry.text = "**/**"
//            btnShowHidePin.setImage(UIImage.eye, for: .normal)
//        }
    }
    func formatDateString(inputString: String) -> String {
        // Ensure the string is exactly 4 characters long
        guard inputString.count == 4 else {
            return "Invalid input"
        }
        
        // Insert "/"
        let formattedString = inputString.prefix(2) + "/" + inputString.suffix(2)
        
        // Return the formatted string
        return String(formattedString)
    }
    
    @IBAction func btnCardFlipFrontClicked(_ sender: UIButton) {
        HapticFeedback.generate(.light)
            self.vwCardBackSide.isHidden = false
            self.vwCardFrontSide.isHidden = true
            let fromView = isFlipped ? vwCardBackSide : vwCardFrontSide
            let toView = isFlipped ? vwCardFrontSide : vwCardBackSide
            UIView.transition(from: fromView!, to: toView!, duration: 0.8, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: { _ in
                self.isFlipped.toggle()
            })
        }
    
    @IBAction func btnShowHideBalanceClicked(_ sender: UIButton) {
        HapticFeedback.generate(.light)
        if !self.btnShowHideBalance.isSelected {
            self.btnShowHideBalance.isSelected = true
            self.lblCardBalance.text = "\(self.balanceValue) \(arrCardList?.balance?.currency ?? "")"
        } else {
            self.btnShowHideBalance.isSelected = false
            self.lblCardBalance.text = "\(self.balanceValue.prefix(2) + "****")"
        }
    }
    
    @IBAction func btnCardFlipBackClicked(_ sender: UIButton) {
        HapticFeedback.generate(.light)
            self.vwCardFrontSide.isHidden = false
            self.vwCardBackSide.isHidden = true
            let fromView = isFlipped ? vwCardBackSide : vwCardFrontSide
            let toView = isFlipped ? vwCardFrontSide : vwCardBackSide
            UIView.transition(from: fromView!, to: toView!, duration: 0.8, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: { _ in
                self.isFlipped.toggle()
            })
        }
    
    @IBAction func btnSeeAllClicked(_ sender: UIButton) {
        HapticFeedback.generate(.light)
        let historyDetailsVC = AllCardHistoryViewController()
        historyDetailsVC.hidesBottomBarWhenPushed = true
        historyDetailsVC.arrCardList = self.arrCardList
        //historyDetailsVC.allTransactionData = transactionsData
        self.navigationController?.pushViewController(historyDetailsVC, animated: true)
    }
    
    @IBAction func btnCancelAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        DGProgressView.shared.showLoader(to: view)
        myCardViewModel.cancelCardRequestsAPINew(cardRequestId: "\(self.cardRequestId ?? 0)") { resStatus, resMsg, dataValue in
            if resStatus == 1 {
                DGProgressView.shared.hideLoader()
                self.showToast(message: "OK", font: AppFont.regular(15).value)
                self.navigationController?.popViewController(animated: true)
            } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: "Error", font: AppFont.regular(15).value)
            }
        }
    }
    
    @IBAction func btnUpdateCardAdressAction(_ sender: Any) {
        HapticFeedback.generate(.light)
//        let updateAddressVC = UpdateCardRequestAddressViewController()
//        updateAddressVC.cardRequestId = self.cardRequestId
//        updateAddressVC.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(updateAddressVC, animated: true)
    }
}
extension MyCardDetailsViewController {
    func showLastFourDigits(of input: String) -> String {
        let length = input.count
        guard length > 4 else {
            return input
        }
        let start = input.index(input.endIndex, offsetBy: -4)
        let lastFour = input[start..<input.endIndex]
        return "***" + lastFour
    }
}

extension MyCardDetailsViewController {
    
    func getPublicKay() {
        myCardDetailsViewModel.cardPublicPrivateKeyAPINew { resStatus, dataValue in
            print(dataValue)
        }
    }
    func convertToSecKey(from base64Key: String) -> SecKey? {
        // Remove PEM header and footer if present
        let cleanedKey = base64Key
            .replacingOccurrences(of: "-----BEGIN RSA PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "-----END RSA PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "\n", with: "")

        guard let keyData = Data(base64Encoded: cleanedKey, options: .ignoreUnknownCharacters) else {
            print("Failed to decode base64 private key.")
            return nil
        }

        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecAttrKeySizeInBits as String: 2048
        ]

        var error: Unmanaged<CFError>?
        let secKey = SecKeyCreateWithData(keyData as CFData, attributes as CFDictionary, &error)

        if let error = error?.takeRetainedValue() {
            print("Error creating private key: \(error)")
            return nil
        }

        return secKey
    }
    func getCardNumber() {
        DGProgressView.shared.showLoader(to: view)
        let encodePublicKey1="MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCPojCQrnDjipNIXrZJqGDKGJ4B8mmpLyVuX8nEcZmj8gkSpo4r8vwztj7C28XyHOjow9lOZ1k6MI0cT6j9CYxQj6xxzIbbDP7y5EnfFe/FcYE93NVSwdCnHWl/tSkWuoOEvJnFKsjSahvDSTm9Uy30E4xTeynPRc02YQKh+FyRhQIDAQAB"
        myCardDetailsViewModel.apiCardNumberNew(cardId: "\(arrCardList?.id ?? 0)", publicKey: encodePublicKey1) { resStatus,resMsg, dataValue in
            if resStatus == 1 && dataValue != nil {
                let error:UnsafeMutablePointer<Unmanaged<CFError>?>? = nil
                self.myCardDetailsViewModel.apiCardNumberDecrypted(number: dataValue?.number ?? "", cardHolderName: dataValue?.cardholderName ?? "") { resStatus, resMsg, dataValue in
                    if resStatus == 1 {
                        DGProgressView.shared.hideLoader()
                        DispatchQueue.main.async {
                            self.lblCardNumber.text = dataValue?.number
                            self.lblCardUserName.text = dataValue?.cardholderName
                           // UserDefaults.standard.set(dataValue?.number, forKey: cryptoCardNumber)
                        }
                    } else {
                        DGProgressView.shared.hideLoader()
                    }
                }
            } else {
                DGProgressView.shared.hideLoader()
            }
        }
    }
    func getCardDetail() {
        DGProgressView.shared.showLoader(to: view)
        let encodePublicKey1="MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCPojCQrnDjipNIXrZJqGDKGJ4B8mmpLyVuX8nEcZmj8gkSpo4r8vwztj7C28XyHOjow9lOZ1k6MI0cT6j9CYxQj6xxzIbbDP7y5EnfFe/FcYE93NVSwdCnHWl/tSkWuoOEvJnFKsjSahvDSTm9Uy30E4xTeynPRc02YQKh+FyRhQIDAQAB"

        myCardDetailsViewModel.apiCardInformatonNew(cardId: "\(arrCardList?.id ?? 0)", code: "", publicKey: encodePublicKey1) { status,msg, data in
            if status == 1 {
                
                self.myCardDetailsViewModel.apiCardInformatonDecrypted(number: data?.number ?? "", expiry: data?.expiry ?? "", cvv: data?.cvv ?? "", cardholderName: data?.cardholderName ?? "") { status,msg, data in
                    if status == 1 {
                        DGProgressView.shared.hideLoader()
                            if self.isFrom == "cardExpiry" {
                                self.getMasterCardInfoDetails(cardNumber:  "", cardCVV:data?.cvv ?? "" , cardExpiryDate:data?.expiry , cardHolderName:"", isFrom: "cardExpiry")
                            } else {
                                self.getMasterCardInfoDetails(cardNumber: "", cardCVV:data?.cvv ?? "" , cardExpiryDate:data?.expiry , cardHolderName:"", isFrom: "pinNo")
                            }
                    } else {
                        DGProgressView.shared.hideLoader()
                    }
                }
                
            } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: "Card not found", font: AppFont.regular(15).value)
            }
        }
    }
    
    func getCardInfoCode(isFrom:String) {
        DGProgressView.shared.showLoader(to: view)
        myCardDetailsViewModel.apiCardInformatonCodeSendNew(cardId: "\(arrCardList?.id ?? 0)", code: "") { status,msg, data in
            if status == 1 {
                DGProgressView.shared.hideLoader()
                self.getCardDetail()
                    /*let presentInfoVc = ShowOTPViewController()
                    //                presentInfoVc.alertData = .sellCryptoWarning
                    presentInfoVc.modalTransitionStyle = .crossDissolve
                    presentInfoVc.modalPresentationStyle = .overFullScreen
                    presentInfoVc.delegate = self
                    presentInfoVc.arrCardList = self.arrCardList
                    presentInfoVc.publicKey = self.publicKey
                if isFrom == "cardExpiry" {
                    presentInfoVc.isFrom = "cardExpiry"
                } else {
                    presentInfoVc.isFrom = "pinNo"
                }
                    presentInfoVc.isFromCardFreeze = false
                    presentInfoVc.isFromCardDetails = true
                    presentInfoVc.isFromCardUnFreeze = false
                    self.present(presentInfoVc, animated: true, completion: nil)*/
                if isFrom == "cardExpiry" && isFrom == "pinNo" {
                    self.arrMenuOptions[2] = MenuOptionsList(title: "Details", image: UIImage.icDetailsHide)
                    self.clvMenuOptions.reloadData()
                } else {
                    self.arrMenuOptions[2] = MenuOptionsList(title: "Details", image: UIImage.icDetails)
                    self.clvMenuOptions.reloadData()
                }
                
//                self.showToast(message: msg, font: AppFont.regular(15).value)
            } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: "error", font: AppFont.regular(15).value)
            }
        }
    }
    func getCardHistory(cardId:String?,size:Int? = 0,completion: @escaping () -> Void) {
//        DGProgressView.shared.showLoader(to: view)
        self.tbvHisotry.showLoader()
        myCardDetailsViewModel.apiGetCardHistoryNew(offset: 0, size: size ?? 0, cardId: cardId ?? "") { status, msg, data in
           
            if status == 1 {
//                DGProgressView.shared.hideLoader()
                if !(data?.isEmpty ?? false) {
                    self.arrCardHistory = data ?? []
                    self.organizeChatMessagesByDate()
                    DispatchQueue.main.async {
                        self.tbvHisotry.hideLoader()
                        self.tbvHisotry.reloadData()
                        self.tbvHisotry.restore()
                    }
                } else {
                   // self.isFetchingData = true
                }
                
            } else {
                self.tbvHisotry.hideLoader()
//                DGProgressView.shared.hideLoader()
                self.showToast(message: msg, font: AppFont.regular(15).value)
            }
        }
    }
    
    func organizeChatMessagesByDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let calendar = Calendar.current
        var sections = [CardHistorySection]()

        for transaction in arrCardHistory {
            if let sendOnDate = dateFormatter.date(from: transaction.operationDate ?? "") {
                var foundSection = false

                for index in 0..<sections.count {
                    let section = sections[index]

                    if calendar.isDate(sendOnDate, inSameDayAs: dateFormatter.date(from: section.date ?? "")!) {
                        sections[index].data?.append(transaction)
                        foundSection = true
                        break
                    }
                }

                if !foundSection {
                    sections.append(CardHistorySection(date: dateFormatter.string(from: sendOnDate), data: [transaction]))
                }
            }
        }

        // Sort sections by date
        sections.sort { (lhs, rhs) -> Bool in
            return dateFormatter.date(from: lhs.date ?? "")! > dateFormatter.date(from: rhs.date ?? "")!
        }

        transactionsByDate = sections
        self.tbvHisotry.reloadData()
    
    }
}
extension  MyCardDetailsViewController : MasterCardInfoDetailsDelegate {
    func gobackToHome(isFreeze: Bool) {
        if let navigationController = self.navigationController {
            for viewController in navigationController.viewControllers {
                if viewController is CardDashBoardViewController {
                    NotificationCenter.default.post(name: NSNotification.Name("RefreshCardDashBoard"), object: nil)
                    navigationController.popToViewController(viewController, animated: false)
                    break
                }
            }
        }
        
    }
    
    func getMasterCardInfoDetails(cardNumber: String, cardCVV: String, cardExpiryDate: String?, cardHolderName: String?,isFrom: String) {
        
        self.decryptedCardNo =  cardNumber
        self.decryptedCardCvv =  cardCVV
        self.decryptedCardExpiry = cardExpiryDate ?? ""
        self.decryptedCardName =  cardHolderName ?? ""
        self.isFrom = isFrom
        // Refresh the UI on the main thread
                DispatchQueue.main.async {
                    self.updateUI()
         }
    }
}

extension MyCardDetailsViewController {
    // Convert Base64 String to Data
    func base64ToData(_ base64String: String) -> Data? {
        return Data(base64Encoded: base64String, options: .ignoreUnknownCharacters)
    }
    func loadPrivateKey(pemString: String) -> SecKey? {
        // Remove PEM headers and footers
        let keyString = pemString
            .replacingOccurrences(of: "-----BEGIN PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "-----END PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")

        // Decode Base64 string to Data
        guard let keyData = Data(base64Encoded: keyString) else {
            print("❌ Failed to decode Base64 private key")
            return nil
        }

        // Define key attributes
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecAttrKeySizeInBits as String: 2048
        ]

        // Create SecKey from key data
        var error: Unmanaged<CFError>?
        guard let secKey = SecKeyCreateWithData(keyData as CFData, attributes as CFDictionary, &error) else {
            if let error = error?.takeRetainedValue() {
                print("❌ Error creating SecKey: \(error)")
            }
            return nil
        }

        print("✅ Private key loaded successfully")
        return secKey
    }
    // Load RSA Private Key from PEM String
//    func loadPrivateKey() -> SecKey? {
//        guard let keyURL = Bundle.main.url(forResource: "private_key", withExtension: "der"),
//              let keyData = try? Data(contentsOf: keyURL) else {
//            print("❌ private_key.der NOT FOUND")
//            return nil
//        }
//
//        print("✅ Loaded private_key.der successfully, size: \(keyData.count) bytes")
//        print("🔹 Key Data (Base64): \(keyData.base64EncodedString())")
//
//        let keyDict: [String: Any] = [
//            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
//            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
//            kSecAttrKeySizeInBits as String: 2048  // Adjust based on your key size
//        ]
//
//        var error: Unmanaged<CFError>?
//        guard let privateKey = SecKeyCreateWithData(keyData as CFData, keyDict as CFDictionary, &error) else {
//            if let error = error?.takeRetainedValue() {
//                print("❌ SecKeyCreateWithData Error: \(error.localizedDescription)")
//            } else {
//                print("❌ Unknown error while loading private key")
//            }
//            return nil
//        }
//
//        print("✅ Successfully created SecKey")
//        return privateKey
//    }



    func decryptRSA(encryptedData: Data) -> String? {
        guard let privateKey = loadPrivateKey(pemString: "") else {
            print("❌ Private key is missing")
            return nil
        }
        
        // Try with PKCS1 padding first (most common)
        let algorithm: SecKeyAlgorithm = .rsaEncryptionPKCS1

        // Check if algorithm is supported
        if !SecKeyIsAlgorithmSupported(privateKey, .decrypt, algorithm) {
            print("❌ Algorithm not supported")
            return nil
        }

        var error: Unmanaged<CFError>?
        guard let decryptedData = SecKeyCreateDecryptedData(privateKey,
                                                            algorithm,
                                                            encryptedData as CFData,
                                                            &error) else {
            print("❌ RSA Decryption failed:", error?.takeRetainedValue() as Error? ?? "Unknown error")
            return nil
        }

        // Convert decrypted data to a string
        if let decryptedString = String(data: decryptedData as Data, encoding: .utf8) {
            print("✅ Decryption Success: \(decryptedString)")
            return decryptedString
        } else {
            print("❌ Decryption succeeded but output is not a valid UTF-8 string")
            return nil
        }
    }

}
