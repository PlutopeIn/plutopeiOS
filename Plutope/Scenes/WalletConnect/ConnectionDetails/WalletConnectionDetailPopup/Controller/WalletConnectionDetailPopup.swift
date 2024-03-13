//
//  WalletConnectionDetailPopup.swift
//  Plutope
//
//  Created by Trupti Mistry on 06/02/24.
//

import UIKit
import Combine
import Auth
import Web3Wallet
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
        if let chains = session.requiredNamespaces["eip155"]?.chains {
            // chains is an optional value, so make sure it's not nil before using it
            var chainsArray = Array(chains)
            
            for element in chainsArray {
                if let val = element as? Blockchain {
                    self.chainsArray.append(val.absoluteString)
                }
            }
        } else {
            // Handle the case where the chains property is nil
            print("Chains property is nil")
        }
        
//        var combinedChains = Set<Blockchain>()
//
//        if let requiredChains = session.requiredNamespaces["eip155"]?.chains {
//            combinedChains.formUnion(requiredChains)
//        }
//
//        if let optionalChains = session.namespaces["eip155"]?.chains {
//            combinedChains.formUnion(optionalChains)
//        }
//
//        // Convert combinedChains to an array of Blockchain objects
//        var chainsArray: [String] = combinedChains.compactMap { element in
//            guard let val = element as? Blockchain else { return nil }
//            return val.absoluteString
//        }
//        // Sort chainsArray so that required namespaces are displayed first
//        self.chainsArray.sort { element1, element2 in
//            let isRequired1 = session.requiredNamespaces["eip155"]?.chains?.contains { $0.absoluteString == element1 } ?? false
//            let isRequired2 = session.requiredNamespaces["eip155"]?.chains?.contains { $0.absoluteString == element2 } ?? false
//
//            if isRequired1 && !isRequired2 {
//                return true
//            } else if !isRequired1 && isRequired2 {
//                return false
//            } else {
//                return element1 < element2
//            }
//        }
//        // Append the elements to chainsArray
//        self.chainsArray.append(contentsOf: chainsArray)
        lblName.text = "\(session.peer.name) "
        lblUrl.text = "\(session.peer.url)"
        // Create URL
        ivProvider.sd_setImage(with: URL(string: "\(session.peer.icons)"), placeholderImage: UIImage.icwalletConnectIcon)
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
        self.onDelete()
    }
    // delete session
    func onDelete() {
        Task {
            do {
                try await interactor.disconnectSession(session:session)
                DispatchQueue.main.async {
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
