//
//  CurrencyViewController.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//

import UIKit
import CoreData

class CurrencyViewController: UIViewController, Reusable {
    
    @IBOutlet weak var txtSearch: customTextField!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tbvCurrency: UITableView!
    
    weak var delegate: CurrencyUpdateDelegate?
    var isFromSetting: Bool = false
    var supportedCurrencyList = ["eos", "xrp", "xlm", "link", "dot", "yfi", "usd", "aed", "ars", "aud", "bdt", "bhd", "bmd", "brl", "cad", "chf", "clp", "cny", "czk", "dkk", "eur", "gbp", "gel", "hkd", "idr", "ils", "inr", "jpy", "krw", "kwd", "lkr", "mmk", "mxn", "myr", "ngn", "nok", "nzd", "php", "pkr", "pln", "rub", "sar", "sek", "sgd", "thb", "try", "twd", "uah", "vef", "vnd", "zar", "xdr", "xag", "xau", "bits", "sats"]

    lazy var viewModel: CurrencyViewModel = {
        CurrencyViewModel { status, message in
            if status == false {
                self.showToast(message: message, font: AppFont.regular(15).value)
            }
        }
    }()
    
    var arrCurrency = (DatabaseHelper.shared.retrieveData("Currencies") as? [Currencies])?.sorted(by: { ($0.symbol ?? "") < ($1.symbol ?? "") })
    var arrFilteredCurrency: [Currencies]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Navigation Header
        
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.currency, comment: ""))
        
        self.txtSearch.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.search, comment: "")
        /// Table View Register
        tableRegister()
        
        txtSearch.delegate = self
        // Assuming arrCurrency is an array of Currencies objects
        var filteredCurrencies = arrCurrency?.filter { currency in
            guard let symbol = currency.symbol?.lowercased() else { return false }
            return supportedCurrencyList.contains(symbol)
        }
        arrFilteredCurrency = filteredCurrencies
        arrCurrency = filteredCurrencies
        print(arrFilteredCurrency)
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
}

// MARK: TextField Delegate
extension CurrencyViewController: UITextFieldDelegate {
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
        self.arrCurrency = arrFilteredCurrency?.filter { asset in
            let type = asset.symbol
            let symbol = asset.name
            
            // Match the entered text with name or symbol
            return type?.localizedCaseInsensitiveContains(searchText) ?? false ||
            symbol?.localizedCaseInsensitiveContains(searchText) ?? false
        }
    }
}
