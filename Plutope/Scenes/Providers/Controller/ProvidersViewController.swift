//
//  ProvidersViewController.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
class ProvidersViewController: UIViewController, Reusable {
   
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tbvProviders: UITableView!
    
    weak var delegate: ProviderSelectDelegate?
    var coinDetail: Token?
    var arrProviderList: [BuyProviders] = []
    var providerType : ProviderType = .buy
    var selectedCurrency : Currencies?
    override func viewDidLoad() {
        super.viewDidLoad()
      
        /// Navigation header
        defineHeader(headerView: headerView, titleText: StringConstants.providers)
        
        /// Table Register
        tableRegister()
        
       // self.arrProviderList = coinDetail?.chain!.providers ?? []
        
    }
    
    func tableRegister() {
        tbvProviders.delegate = self
        tbvProviders.dataSource = self
        tbvProviders.register(UINib(nibName: "CoinListViewCell", bundle: nil), forCellReuseIdentifier: "CoinListViewCell")
    }
}
