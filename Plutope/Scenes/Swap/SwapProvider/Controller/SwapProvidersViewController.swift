//
//  SwapProvidersViewController.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
class SwapProvidersViewController: UIViewController, Reusable {
   
    @IBOutlet weak var tbvHeight: NSLayoutConstraint!
    @IBOutlet weak var btnclose: UIButton!
   
    @IBOutlet weak var lblQuotsOverview: UILabel!
    @IBOutlet weak var tbvProviders: UITableView!
    
    weak var delegate: SwapProviderSelectDelegate?
    var coinDetail: Token?
    var arrProviderList: [SwapProviders] = []
    var providerType : ProviderType = .swap
    var selectedCurrency : Currencies?
    var bestPrice : Double?
    var fromCurruncySymbol : String?
    var bestQuote : String?
    var swapperFee : String?
    override func viewDidLoad() {
        super.viewDidLoad()
      
        /// Navigation header
        lblQuotsOverview.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.quotsOverview, comment: "")
        /// Table Register
        tableRegister()
        
       // self.arrProviderList = coinDetail?.chain!.providers ?? []
        
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    func tableRegister() {
        tbvProviders.delegate = self
        tbvProviders.dataSource = self
        tbvProviders.register(UINib(nibName: "SwapProvidersViewCell", bundle: nil), forCellReuseIdentifier: "SwapProvidersViewCell")
    }
}
