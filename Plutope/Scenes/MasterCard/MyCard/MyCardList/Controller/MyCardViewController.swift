//
//  MyCardViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 17/05/24.
//

import UIKit
protocol TopupCardDelegate:AnyObject {
    func selectedCard(tokenName:String,tokenbalance:String,tokenAmount:String,tokenCurruncy:String,cardDesignId:String,cardType:String)
}
class MyCardViewController: UIViewController {

    @IBOutlet weak var txtSearch: customTextField!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var tbvCard: UITableView!
    @IBOutlet weak var ivAddCard: UIImageView!
    @IBOutlet weak var headerView: UIView!
    var arrCardList : [Card] = []
    var filterCards : [Card] = []
    var cardPrice = ""
    var isFrom = ""
    var isSearching: Bool = false
    let server = serverTypes
    weak var carddelegate : TopupCardDelegate?
    lazy var myCardViewModel: MyCardViewModel = {
        MyCardViewModel { _ ,message in
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation header
        self.txtSearch.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.search, comment: "")
       
        /// Table Register
        tableRegister()
        if isFrom == "topupVC" {
            headerView.isHidden = false
            ivAddCard.isHidden = true
            headerHeight.constant = 70
            self.filterCards = self.arrCardList
            defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.selectCard, comment: ""), btnBackHidden: true,btnRightImage: UIImage.cancel) {
                HapticFeedback.generate(.light)
                print("clicked")
                self.dismiss(animated: true)
                
            }
        } else {
            /// fetch card data
            
            self.getCardNew()
           
            headerView.isHidden = false
            ivAddCard.isHidden = false
            headerHeight.constant = 70
            defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.selectCard, comment: ""), btnBackHidden: false)
        }
        self.txtSearch.delegate = self
        ivAddCard.addTapGesture {
            HapticFeedback.generate(.light)
            let vcToPresent = AddNewCardViewController()
            vcToPresent.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vcToPresent, animated: true)
           
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtSearch.textAlignment = (LocalizationSystem.sharedInstance.getLanguage() == "ar") ? .right : .left
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        txtSearch.text = ""
        txtSearch.resignFirstResponder()
        isSearching = false
    }
    /// Table Register
    func tableRegister() {
        tbvCard.delegate = self
        tbvCard.dataSource = self
        tbvCard.register(MyCardTableViewCell.nib, forCellReuseIdentifier: MyCardTableViewCell.reuseIdentifier)

    }
    func getCard() {
        DGProgressView.shared.showLoader(to: view)
        
        myCardViewModel.getCardAPINew { status, msg,data in
            if status == 1 {
                DGProgressView.shared.hideLoader()
                self.arrCardList = data ?? []
                self.filterCards = self.arrCardList
                DispatchQueue.main.async {
                    self.tbvCard.reloadData()
                    self.tbvCard.restore()
                }
                
            } else {
                DGProgressView.shared.hideLoader()
            }
        }

    }

}
extension MyCardViewController {
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
extension MyCardViewController: UITextFieldDelegate {
    
    // Implement the UITextFieldDelegate method to perform the search
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !(textField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false) {
            isSearching = true
            filterAssets(with: textField.text ?? "")
        } else {
            isSearching = false
            self.arrCardList = filterCards
        }
        tbvCard.reloadData()
    }
    
    func filterAssets(with searchText: String) {
        self.arrCardList = filterCards.filter { asset in
            let type = asset.cardCompany
            let symbol = asset.number
            let symbol1 = asset.cardDesignID
            
            // Match the entered text with name or symbol
            return type?.localizedCaseInsensitiveContains(searchText) ?? false || symbol?.localizedCaseInsensitiveContains(searchText) ?? false || symbol1?.localizedCaseInsensitiveContains(searchText) ?? false
        }
    }
    
}
