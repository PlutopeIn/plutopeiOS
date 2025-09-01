//
//  SellViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 22/04/25.
//

import UIKit

class SellViewController: UIViewController ,Reusable {

    
    @IBOutlet weak var txtSearch: customTextField!
    @IBOutlet weak var tbvSellProviderList: UITableView!
    @IBOutlet weak var headerView: UIView!
    var isSearching: Bool = false
    var coinDetail: Token?
   
    var sellProviderList: [SellProviderList]? = []
    var filterProviderList: [SellProviderList]? = []
    lazy var viewModel : SellViewModel =  { SellViewModel {_, _ in
    }
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        /// Navigation Header
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.sell, comment: ""))
        self.txtSearch.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.search, comment: "")
        txtSearch.font = AppFont.regular(15).value
        txtSearch.delegate = self
        /// Table register
        tableRegister()
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                txtSearch.textAlignment = .right
            } else {
                txtSearch.textAlignment = .left
            }
        self.getSellProvider()
        }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        txtSearch.text = ""
        txtSearch.resignFirstResponder()
        isSearching = false
    }
    /// Table register
    func tableRegister() {
        tbvSellProviderList.delegate = self
        tbvSellProviderList.dataSource = self
        tbvSellProviderList.register(SellTableviewCell.nib, forCellReuseIdentifier: SellTableviewCell.reuseIdentifier)
    }

    func getSellProvider() {
        DGProgressView.shared.showLoader(to: view)
        viewModel.apiGetSellProvider { status, msg, resData in
            if status == 1 {
                
                DispatchQueue.main.async {
                    self.sellProviderList = resData ?? []
                    print("sellprovider = ",self.sellProviderList)
                    self.filterProviderList = self.sellProviderList
                    if self.sellProviderList?.isEmpty ?? false {
                        DGProgressView.shared.hideLoader()
                        self.tbvSellProviderList.setEmptyMessage(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.noData, comment: ""), font: AppFont.violetRegular(15).value, textColor: UIColor.label)
                    } else {
                        self.tbvSellProviderList.reloadData()
                        DGProgressView.shared.hideLoader()
//                        self.tbvSellProviderList.restore()
                    }
                    
                }
            } else {
                DispatchQueue.main.async {

                    self.showToast(message: msg, font: AppFont.regular(15).value)
                }
            }
        }
    }
}
