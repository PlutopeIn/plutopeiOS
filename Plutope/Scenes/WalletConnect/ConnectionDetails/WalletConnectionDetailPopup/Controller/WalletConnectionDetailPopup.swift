//
//  WalletConnectionDetailPopup.swift
//  Plutope
//
//  Created by Trupti Mistry on 06/02/24.
//

import UIKit
import Combine
//import Auth
//import Web3Wallet
import ReownWalletKit
import SDWebImage
class WalletConnectionDetailPopup: UIViewController {
    
    @IBOutlet weak var tbvAccount: UITableView!
    @IBOutlet weak var lblUrl: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ivProvider: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tbvHeight: NSLayoutConstraint!
    @IBOutlet weak var lblNetworkTitle: UILabel!
    @IBOutlet weak var lblWalletTitle: UILabel!
    @IBOutlet weak var ivConnection: UIImageView!
    @IBOutlet weak var lblWalletAddress: UILabel!
    var chainsArray = [String]()
    var filteredChainsArray: [String] = []
    @IBOutlet weak var btnRemoveConnection: UIButton!
    let session: Session
    private let interactor: ConnectionDetailsInteractor
    init(
        interactor: ConnectionDetailsInteractor,
        session: Session
       
    ) {
        self.interactor = interactor
        self.session = session
      
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func uiSetUp() {
        if let chains = session.namespaces["eip155"]?.chains {
            // chains is an optional value, so make sure it's not nil before using it
            var chainsArray = Array(chains)
            
            for element in chainsArray {
                if let val = element as? Blockchain {
                    self.chainsArray.append(val.absoluteString)
                }
            }
            let allowedChains: Set<String> = [
                       "eip155:56",  // Binance Smart Chain
                       "eip155:1",   // Ethereum
                       "eip155:137", // Polygon
                       "eip155:66",  // OKC
                       "eip155:10",  // Optimism Mainnet
                       "eip155:42161", // Arbitrum
                       "eip155:43114", // Avalanche
                       "eip155:8453",  // Base
                       "eip155:97"     // Binance Smart Chain (Testnet?)
                   ]
            filteredChainsArray = self.chainsArray.filter { allowedChains.contains($0) }
        } else {
            // Handle the case where the chains property is nil
            print("Chains property is nil")
        }
        btnRemoveConnection.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.connectionRemove, comment: ""), for: .normal)
        
        lblWalletTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wallet, comment: "")
        lblNetworkTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.network, comment: "")
        lblName.text = "\(session.peer.name) "
        lblUrl.text = "\(session.peer.url)"
        lblWalletAddress.text = WalletData.shared.myWallet?.address
        // Create URL
        
        let icon = session.peer.icons
         let firsticon = icon.first ?? ""
         let imageUrl = URL(string: firsticon)

                 // Set the image in the UIImageView using SDWebImage
        ivProvider.sd_setImage(with: imageUrl, placeholderImage: UIImage.icwalletConnectIcon)
//        ivProvider.sd_setImage(with: URL(string: "\(session.peer.icons)"), placeholderImage: UIImage.icwalletConnectIcon)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // table Register
        tableRegister()
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.connectionDetail, comment: ""))
        // uiSetUp
        uiSetUp()
        
    }
    // remove session Action
    @IBAction func btnRemoveAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        self.onDelete()
    }
    // delete session
    func onDelete() {
        Task {
            do {
                try await interactor.disconnectSession(session:session)
                DispatchQueue.main.async {
                    UserDefaults.standard.removeObject(forKey: "sessionName") 
                    UserDefaults.standard.set(false, forKey: "isConnected") 
                    self.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func accountReferences(namespace: String) -> [String] {
        session.namespaces[namespace]?.accounts.map { "\($0.namespace):\(($0.reference))" } ?? []
    }
    /// Table Register
    func tableRegister() {
        tbvAccount.delegate = self
        tbvAccount.dataSource = self
        tbvAccount.register(WalletConnectPopupTbvCell.nib, forCellReuseIdentifier: WalletConnectPopupTbvCell.reuseIdentifier)
    }
}
