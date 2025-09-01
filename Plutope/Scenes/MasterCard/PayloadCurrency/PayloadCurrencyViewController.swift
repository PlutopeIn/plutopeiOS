//
//  PayloadCurrencyViewController.swift
//  Plutope
//
//  Created by Priyanka on 05/06/24.
//

import UIKit
protocol SelectedCurrencyDelegate : AnyObject {
    func getSelectedCurrency(name:String)
}

class PayloadCurrencyViewController: UIViewController, Reusable {
    
    @IBOutlet weak var ivClose: UIImageView!
    @IBOutlet weak var txtSearch: customTextField!
    @IBOutlet weak var tbvCurrency: UITableView!
    
    weak var delegate: SelectedCurrencyDelegate?
    var arrCurrency : [String] = []
    var arrFilteredCurrency : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtSearch.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.search, comment: "")
        txtSearch.delegate = self
        /// Table View Register
        tableRegister()
        arrFilteredCurrency = arrCurrency
        ivClose.addTapGesture {
            HapticFeedback.generate(.light)
            self.dismiss(animated: true)
        }
        
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
extension PayloadCurrencyViewController: UITextFieldDelegate {
    // Implement the UITextFieldDelegate method to perform the search
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let searchText = textField.text?.trimmingCharacters(in: .whitespaces), !searchText.isEmpty {
            self.arrCurrency = filterCurrencies(currencies: arrFilteredCurrency, with: searchText)
        } else {
            self.arrCurrency = arrFilteredCurrency
        }
        tbvCurrency.reloadData()
    }
    
    // Function to filter currencies based on search text
    func filterCurrencies(currencies: [String]?, with searchText: String) -> [String] {
        guard let currencies = currencies else {
            return []
        }
        
        return currencies.filter { currency in
            return currency.localizedCaseInsensitiveContains(searchText)
        }
    }
}
// MARK: - UITableViewDataSource methods
extension PayloadCurrencyViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.arrCurrency.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvCurrency.dequeueReusableCell(indexPath: indexPath) as CurrencyViewCell
        cell.selectionStyle = .none
        let data = self.arrCurrency[indexPath.row]
        cell.lblCurrency.text = data
        cell.ivSelected.isHidden = true
        return cell
    }
    
}
// MARK: - UITableViewDelegate methods
extension PayloadCurrencyViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        let cell = tbvCurrency.cellForRow(at: indexPath) as? CurrencyViewCell
        let data = arrCurrency[indexPath.row]
        self.dismiss(animated: true) {
            self.delegate?.getSelectedCurrency(name: data)
        }
    }
}
