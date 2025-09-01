//
//  SwapProvidersViewController.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
class SwapProvidersViewController: UIViewController, Reusable {
   
    @IBOutlet weak var lblTokenName: UILabel!
    @IBOutlet weak var tbvHeight: NSLayoutConstraint!
    @IBOutlet weak var btnclose: UIButton!
   
    @IBOutlet weak var lblQuotsOverview: UILabel!
    @IBOutlet weak var tbvProviders: UITableView!
    
    weak var delegate: SwapProviderSelectDelegate?
    var coinDetail: Token?
    var getCoinDetail:Token?
    var arrProviderList: [SwapProviders] = []
    var swapArrProviderList = [SwapMeargedDataList]()
    var providerType : ProviderType = .swap
    var selectedCurrency : Currencies?
    var bestPrice : Double?
    var fromCurruncySymbol : String?
    var bestQuote : String?
    var swapperFee : String?
    var providerImage : String?
    var providerName : String?
    var quotAmount = ""
    override func viewDidLoad() {
        super.viewDidLoad()
      print(swapArrProviderList)
        /// Navigation header
        lblQuotsOverview.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.provider, comment: "")
        /// Table Register
        tableRegister()
        lblTokenName.text = "\(self.fromCurruncySymbol ?? "") \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.receiving, comment: ""))"
        lblTokenName.font = AppFont.regular(14).value
        lblQuotsOverview.font = AppFont.violetRegular(20).value
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tbvProviders.reloadData()
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        self.dismiss(animated: true)
    }
    func tableRegister() {
        tbvProviders.delegate = self
        tbvProviders.dataSource = self
        tbvProviders.register(UINib(nibName: "SwapProvidersViewCell", bundle: nil), forCellReuseIdentifier: "SwapProvidersViewCell")
    }
}
