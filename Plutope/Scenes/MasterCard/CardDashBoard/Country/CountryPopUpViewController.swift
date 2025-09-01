//
//  CountryPopUpViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 03/06/24.
//

import UIKit
import Combine
protocol SelectedCountryDelegate : AnyObject {
    func getSelectedCountry(name:String,code:String,dialCode:String,flag:String,isCountry:Bool?)
}
class CountryPopUpViewController: UIViewController {

    @IBOutlet weak var tbvHeight: NSLayoutConstraint!
    @IBOutlet weak var txtSearch: customTextField!
    
    @IBOutlet weak var ivClose: UIImageView!
    @IBOutlet weak var tbvCountry: UITableView!
    var isSearching: Bool = false
    var countryCode : String? = ""
    weak var delegate : SelectedCountryDelegate?
    private var viewModel = CountryCodeViewModel()
    private var cancellables = Set<AnyCancellable>()
    var arrCountryData: [Country] = []
    var filterCountryData: [Country] = []
    var isFrom = ""
    var isCountry = false
    var filtterPickerData: [CountryList] = []
    var documentCountryPickerData: [CountryList] = []
    lazy var myCardViewModel: MyCardViewModel = {
        MyCardViewModel { _ ,_ in
        }
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtSearch.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.search, comment: "")
        txtSearch.delegate = self
        tableRegister()
        
        if isFrom == "updateAddreess" || isFrom == "profile" || isFrom == "additionalInfo" || isFrom == "billingInfo"{
          //  fetchCountry()
            if AppConstants.storedCountryList == nil {
                fetchCountry()
            } else {
                allReadySaved()
            }
           
        } else {
            /// fetch the country codes
            viewModel.getCountryCode()
            // Subscribe to changes in the countries property to update your UI as needed
            viewModel.$countries
                .sink { [weak self] countries in
                    // Handle the updated countries data here
                    self?.arrCountryData = countries
                    self?.filterCountryData = countries
                    if let india = countries.first(where: { $0.name == "India" }) {
                        // India found in the countries array
                        let indiaDialCode = india.dialCode
                        let indiaFlag = india.flag
                        // Use indiaDialCode as needed, such as setting it in a text field
                        self?.tbvCountry.reloadData()
                    } else {
                        // India not found in the countries array
                        print("India not found in the list of countries.")
                    }
    //                print(countries)
                }
                .store(in: &cancellables)

        }
        txtSearch.font = AppFont.regular(11).value
        
        ivClose.addTapGesture {
            HapticFeedback.generate(.light)
            self.dismiss(animated: true)
        }
    }
    /// Table Register
    func tableRegister() {
        tbvCountry.delegate = self
        tbvCountry.dataSource = self
        tbvCountry.register(CountryTableViewCell.nib, forCellReuseIdentifier: CountryTableViewCell.reuseIdentifier)

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
    
    func fetchCountry() {
        DGProgressView.shared.showLoader(to: self.view)
        myCardViewModel.getCountrisAPI { status, msg, data in
            DispatchQueue.main.async {
                if status == 1 {
                    self.documentCountryPickerData = data ?? []
                    DispatchQueue.main.async {
                        AppConstants.storedCountryList =  data ?? []
                    }
                    
                    self.filtterPickerData = self.documentCountryPickerData
                    DGProgressView.shared.hideLoader()
                   // DispatchQueue.main.async {
                        self.tbvCountry.reloadData()
                        self.tbvCountry.restore()
                   // }
                } else {
                    DGProgressView.shared.hideLoader()
                    print(msg)
                }
            }
        }
    }
     func allReadySaved() {
         self.documentCountryPickerData = AppConstants.storedCountryList ?? []
         self.filtterPickerData = self.documentCountryPickerData
       // DispatchQueue.main.async {
            self.tbvCountry.reloadData()
            self.tbvCountry.restore()
      //  }
    }
}
// MARK: UITextFieldDelegate
extension CountryPopUpViewController: UITextFieldDelegate {
    
    // Implement the UITextFieldDelegate method to perform the search
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !(textField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false) {
            isSearching = true
            filterAssets(with: textField.text ?? "")
        } else {
            isSearching = false
            if isFrom == "updateAddreess" || isFrom == "profile" || isFrom == "additionalInfo" || isFrom == "billingInfo" {
                self.documentCountryPickerData = filtterPickerData
            } else {
                self.arrCountryData = filterCountryData
            }
        }
        tbvCountry.reloadData()
    }
    
    func filterAssets(with searchText: String) {

        if isFrom == "updateAddreess"  || isFrom == "profile"  || isFrom == "additionalInfo"  || isFrom == "billingInfo" {
            self.documentCountryPickerData = filtterPickerData.filter { asset in
                let type = asset.country
                let code = asset.iso3
                // Match the entered text with name or symbol
                return type?.localizedCaseInsensitiveContains(searchText) ?? false ||   code?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        } else {
            self.arrCountryData = filterCountryData.filter { asset in
                let type = asset.name
                let code = asset.code
                let dail = asset.dialCode
                
                // Match the entered text with name or symbol
                return type?.localizedCaseInsensitiveContains(searchText) ?? false ||   code?.localizedCaseInsensitiveContains(searchText) ?? false ||   dail?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
    }
    
}
// MARK: - UITableViewDataSource methods
extension CountryPopUpViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFrom == "updateAddreess"  || isFrom == "profile" || isFrom == "additionalInfo" || isFrom == "billingInfo" {
            return documentCountryPickerData.count
        } else {
            return self.arrCountryData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvCountry.dequeueReusableCell(indexPath: indexPath) as CountryTableViewCell
        cell.selectionStyle = .none
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.systemGray3
        if isFrom == "updateAddreess"  || isFrom == "profile" || isFrom == "additionalInfo" || isFrom == "billingInfo" {
            let data = documentCountryPickerData[indexPath.row]
            cell.lblToken.text = data.country
            cell.lblFlag.isHidden = true
        } else {
            let data = arrCountryData[indexPath.row]
            cell.lblToken.text = data.name
            cell.lblFlag.text = data.flag ?? ""
        }
       
        return cell
    }
    
}
// MARK: - UITableViewDelegate methods
extension CountryPopUpViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        let cell = tbvCountry.cellForRow(at: indexPath) as? CountryTableViewCell
       
        if isFrom == "updateAddreess"  || isFrom == "profile" || isFrom == "additionalInfo"  {
            let data = documentCountryPickerData[indexPath.row]
            if isCountry == true {
                self.dismiss(animated: true) {
                    self.delegate?.getSelectedCountry(name: data.country ?? "", code: data.iso3 ?? "", dialCode: "", flag: "", isCountry: true)
                }
            } else {
                self.dismiss(animated: true) {
                    self.delegate?.getSelectedCountry(name: data.country ?? "", code: data.iso3 ?? "", dialCode: "", flag: "", isCountry: false)
                }
            }
            
        } else if isFrom == "billingInfo" {
            let data = documentCountryPickerData[indexPath.row]
            if isCountry == true {
                self.dismiss(animated: true) {
                    self.delegate?.getSelectedCountry(name: data.country ?? "", code: data.iso2 ?? "", dialCode: "", flag: "", isCountry: true)
                }
            } else {
                self.dismiss(animated: true) {
                    self.delegate?.getSelectedCountry(name: data.country ?? "", code: data.iso2 ?? "", dialCode: "", flag: "", isCountry: false)
                }
            }
        }else {
            let data = arrCountryData[indexPath.row]
            self.dismiss(animated: true) {
                self.delegate?.getSelectedCountry(name: data.name ?? "", code: data.code ?? "", dialCode: data.dialCode ?? "", flag: data.flag ?? "", isCountry: false)
            }
        }

    }
}
