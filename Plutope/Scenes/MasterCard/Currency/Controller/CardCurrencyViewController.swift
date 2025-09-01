//
//  CardCurrencyViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 02/07/24.
//

import UIKit
import CoreData
protocol SelectCardCurrencyUpdateDelegate : NSObject {
    func selectedCardCureency(selectedCurrency:String)
}

class CardCurrencyViewController: UIViewController, Reusable {
    
    @IBOutlet weak var txtSearch: customTextField!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tbvCurrency: UITableView!
    
    weak var delegate: SelectCardCurrencyUpdateDelegate?
    var supportedCurrencyList = ["usd", "aud", "eur", "gbp", "jpy", "krw"]
    var arrCurrency : [CurrencyList] = []
    lazy var currencyViewModel: CurrencyViewModel = {
        CurrencyViewModel { status, message in
            if status == false {
//                self.showToast(message: message, font: AppFont.regular(15).value)
            }
        }
    }()
    
   // var arrCurrency = (DatabaseHelper.shared.retrieveData("Currencies") as? [Currencies])?.sorted(by: { ($0.symbol ?? "") < ($1.symbol ?? "") })
    var arrFilteredCurrency: [CurrencyList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCurrency()
        /// Navigation Header
        
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.currency, comment: ""))
        
        self.txtSearch.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.search, comment: "")
        /// Table View Register
        tableRegister()
        
        txtSearch.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtSearch.textAlignment = (LocalizationSystem.sharedInstance.getLanguage() == "ar") ? .right : .left
    }
    func tableRegister() {
        tbvCurrency.delegate = self
        tbvCurrency.dataSource = self
        tbvCurrency.register(CurrencyViewCell.nib, forCellReuseIdentifier: CurrencyViewCell.reuseIdentifier)
    }
    
    func getCurrency() {
        currencyViewModel.apiGet { currencyData, status, message in
            if status {
                DispatchQueue.main.async {
                    let currency = currencyData?.sorted(by: { ($0.symbol ?? "") < ($1.symbol ?? "") })
                    // Assuming arrCurrency is an array of Currencies objects
                    let filteredCurrencies = currency?.filter { currency in
                        guard let symbol = currency.symbol?.lowercased() else { return false }
                        return self.supportedCurrencyList.contains(symbol)
                    }
                    self.arrFilteredCurrency = filteredCurrencies ?? []
                    self.arrCurrency = filteredCurrencies ?? []
                    self.tbvCurrency.reloadData()
                    self.tbvCurrency.restore()
                    print(self.arrFilteredCurrency)
                }
            } else {
                self.showToast(message: "Currency data failure", font: AppFont.regular(15).value)
            }
        }
    }
}

// MARK: TextField Delegate
extension CardCurrencyViewController: UITextFieldDelegate {
    // Implement the UITextFieldDelegate method to perform the search
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !(textField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false) {
            filterAssets(with: textField.text ?? "")
        } else {
            self.arrCurrency = arrFilteredCurrency
        }
        tbvCurrency.reloadData()
    }
    
    func filterAssets(with searchText: String) {
        self.arrCurrency = arrFilteredCurrency.filter { asset in
            let type = asset.symbol
            let symbol = asset.name
            
            // Match the entered text with name or symbol
            return type?.localizedCaseInsensitiveContains(searchText) ?? false ||
            symbol?.localizedCaseInsensitiveContains(searchText) ?? false
        }
    }
}
