//
//  MasterCardListViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 18/06/24.
//

import UIKit
protocol SelectMasterCardDelegate:AnyObject {
    func selectedCard(cardNumber:String,cardType:String,tokenimage:String?,cardId:String?,cardFullNo :String, cardBackground: UIColor)
    func addNewCard()
   
}
class MasterCardListViewController: UIViewController {

    @IBOutlet weak var vwDismiss: UIView!
    @IBOutlet weak var lblSelectCard: UILabel!
    @IBOutlet weak var lblAddCard: UILabel!
    @IBOutlet weak var vwAddCard: UIView!
    @IBOutlet weak var btnContactSupport: UIButton!
    @IBOutlet weak var tbvCards: UITableView!
    @IBOutlet weak var constHeightCardsTable: NSLayoutConstraint!
    var isFrom = ""
    var cardName = ""
    var arrCardList : [PayInCard] = []
    var filterCards : [PayInCard] = []
    var arrPayOutCardList : [PayOutCard] = []
    var filterPayOutCardCards : [PayOutCard] = []
    var cardPrice = ""
    var isSearching: Bool = false
    lazy var bankCardPayInViewModel: BankCardPayInViewModel = {
        BankCardPayInViewModel { _ ,_ in
        }
    }()
    lazy var bankCardPayOutViewModel: BankCardPayOutViewModel = {
        BankCardPayOutViewModel { _ ,_ in
        }
    }()
    weak var cardDelegate : SelectMasterCardDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblSelectCard.font = AppFont.violetRegular(20.0).value
        self.lblAddCard.font = AppFont.regular(15.0).value
        self.btnContactSupport.titleLabel?.font = AppFont.violetRegular(14.97).value
        
        self.vwDismiss.addTapGesture {
            HapticFeedback.generate(.light)
            self.dismiss(animated: true, completion: nil)
        }
        
        self.vwAddCard.addTapGesture {
            HapticFeedback.generate(.light)
            self.dismiss(animated: false) {
                self.cardDelegate?.addNewCard()
            }
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name("RefreshMasterCardList"), object: nil)
        
        if isFrom == "withdrawCrypto" {
            getCardPayOutData()
        } else {
            getCardPayInData()
        }
        /// Table Register
        tableRegister()
        lblAddCard.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addNewCard, comment: "")
        lblSelectCard.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.selectCard, comment: "")
        btnContactSupport.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.contactSupportmsg, comment: ""), for: .normal)
    }
    @objc func refreshData() {
        if isFrom == "withdrawCrypto" {
            getCardPayOutData()
        } else {
            getCardPayInData()
        }
      }
    deinit {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("RefreshMasterCardList"), object: nil)
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    
        isSearching = false
    }
    /// Table Register
    func tableRegister() {
        tbvCards.delegate = self
        tbvCards.dataSource = self
        tbvCards.register(MyCardTableViewCell.nib, forCellReuseIdentifier: MyCardTableViewCell.reuseIdentifier)

    }
    @IBAction func btnAddCardAction(_ sender: Any) {
        HapticFeedback.generate(.light)
            let addCardVC = AddMasterCardViewController()
            addCardVC.isFrom = "addMasterCard"
        addCardVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(addCardVC, animated: true)
      
       
    }
    func getCardPayInData() {
        DGProgressView.shared.showLoader(to: view)
        bankCardPayInViewModel.getPayInOtherDataAPI(cardRequestId: "") { resStatus,msg, dataValue in
            if resStatus == 1 {
                DGProgressView.shared.hideLoader()
                self.arrCardList = dataValue?.cards ?? []
                self.filterCards = self.arrCardList
                DispatchQueue.main.async {
                if self.arrCardList.isEmpty {
                    self.tbvCards.setEmptyMessage(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.noCards, comment: ""), font: AppFont.regular(25).value, textColor: UIColor.white)
                } else {
                    self.tbvCards.reloadData()
                }
               }
            } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: msg, font: AppFont.regular(15).value)
            }
        }
    }
    
    func getCardPayOutData() {
        DGProgressView.shared.showLoader(to: view)
        bankCardPayOutViewModel.getPayOutOtherDataLive(cardRequestId: "") { resStatus, dataValue, msg in
            if resStatus == 1 {
                DGProgressView.shared.hideLoader()
                self.arrPayOutCardList = dataValue?.cards ?? []
                self.filterPayOutCardCards = self.arrPayOutCardList
                DispatchQueue.main.async {
                if self.arrCardList.isEmpty {
                    self.tbvCards.setEmptyMessage(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.noCards, comment: ""), font: AppFont.regular(25).value, textColor: UIColor.white)
                } else {
                    self.tbvCards.reloadData()
                }
                    self.tbvCards.restore()
                    self.tbvCards.reloadData()
               }
            } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: msg, font: AppFont.regular(15).value)
            }
        }
    }
    
}
extension MasterCardListViewController {
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
// MARK: UITextFieldDelegate
extension MasterCardListViewController: UITextFieldDelegate {
    
    // Implement the UITextFieldDelegate method to perform the search
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !(textField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false) {
            isSearching = true
            filterAssets(with: textField.text ?? "")
        } else {
            isSearching = false
            if isFrom == "withdrawCrypto" {
                self.arrPayOutCardList = filterPayOutCardCards
            } else {
                self.arrCardList = filterCards
            }
        }
        tbvCards.reloadData()
    }
    
    func filterAssets(with searchText: String) {
        if isFrom == "withdrawCrypto" {
            self.arrPayOutCardList = filterPayOutCardCards.filter { asset in
                //let type = asset.cardType
                let symbol = asset.maskedPan
                let symbol1 = asset.validationStatus
                
                // Match the entered text with name or symbol
                return symbol?.localizedCaseInsensitiveContains(searchText) ?? false || symbol1?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        } else {
            self.arrCardList = filterCards.filter { asset in
                let type = asset.cardType
                let symbol = asset.maskedPan
                let symbol1 = asset.validationStatus
                
                // Match the entered text with name or symbol
                return type?.localizedCaseInsensitiveContains(searchText) ?? false || symbol?.localizedCaseInsensitiveContains(searchText) ?? false || symbol1?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
    }
    
}
