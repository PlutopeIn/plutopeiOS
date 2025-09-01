//
//  DAppConnectPopupViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 08/01/23.
//

import UIKit
import AVFoundation
import ReownWalletKit
import ReownRouter
import Combine
import SDWebImage

struct ProposalNamespaceValue {
    var chains: Set<String>
    var methods: Set<String>
    var events: Set<String>
}
enum Errors: Error {
    case invalidUri(uri: String)
}

class DAppConnectPopupViewController: UIViewController ,Reusable {
    @IBOutlet weak var ivDapp: UIImageView!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnConnect: GradientButton!
    @IBOutlet weak var lblDappName: UILabel!
    
    @IBOutlet weak var lblUrl: UILabel!
    
    @IBOutlet weak var tbvChainType: UITableView!
    @IBOutlet weak var mainView: UIView!
    var url = ""
    @IBOutlet weak var tbvHeight: NSLayoutConstraint!
    @IBOutlet weak var lblParing: UILabel!
    var errorMessage = "Error"
    var showError = false
    var coinDetail: Token?
    private let interactor: SessionProposalInteractor
    let importAccount: ImportAccount
    let sessionProposal: Session.Proposal
    let validationStatus: VerifyContext.ValidationStatus?
    var chainsArray = [String]()
    var filteredChainsArray: [String] = []
    private var disposeBag = Set<AnyCancellable>()
  //  let app: Application
    init(
        interactor: SessionProposalInteractor,
        importAccount: ImportAccount,
        proposal: Session.Proposal,
        context: VerifyContext?
        //app: Application? = nil
    ) {
        defer { setupInitialState() }
       // self.app = app ?? Application()
        self.interactor = interactor //?? SessionProposalInteractor()
        self.sessionProposal = proposal
        self.importAccount = importAccount // ?? ImportAccount.new()
        self.validationStatus = context?.validation
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var onDismiss: (() -> Void)?
    public var allNamespaces: [SessionNamespace] = []
    fileprivate func uiSetUp() {
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = 18
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
       
        if let chains = sessionProposal.optionalNamespaces?["eip155"]?.chains {
            // chains is an optional value, so make sure it's not nil before using it
            let chainsArray = Array(chains)

            for element in chainsArray {
                if let val = element as? Blockchain {
                    self.chainsArray.append(val.absoluteString)
                }
            }
        } else {
            // Handle the case where the chains property is nil
            print("Chains property is nil")
        }
        let allowedChains: Set<String> = [
                   "eip155:56",  // Binance Smart Chain
                   "eip155:1",   // Ethereum
                   "eip155:137", // Polygon
                   "eip155:66",  // OKC
                   "eip155:10",  // Optimism Mainnet
                   "eip155:42161", // Arbitrum
                   "eip155:43114", // Avalanche
                   "eip155:8453"  // Base
                  // "eip155:97"     // Binance Smart Chain (Testnet?)
               ]
        filteredChainsArray = chainsArray.filter { allowedChains.contains($0) }
                
                // Reload the table view with the filtered data
                tbvChainType.reloadData()
        var dappMsg = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wantToConnectMsg, comment: "")
        lblDappName.text = "\(sessionProposal.proposer.name) \(dappMsg)"
        lblParing.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.connectionDApp, comment: "")
        btnCancel.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cancel, comment: ""), for: .normal)
        btnConnect.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.connect, comment: ""), for: .normal)
        UserDefaults.standard.set(sessionProposal.proposer.name, forKey: "sessionName")
        lblUrl.text = "\(sessionProposal.proposer.url)"
        // Create URL
       let icon = sessionProposal.proposer.icons
        let firsticon = icon.first ?? ""
        let imageUrl = URL(string: firsticon)

                // Set the image in the UIImageView using SDWebImage
        ivDapp.sd_setImage(with: imageUrl, placeholderImage: UIImage.icwalletConnectIcon)
//        ivDapp.sd_setImage(with: URL(string: "\(icon)"), placeholderImage: UIImage.icwalletConnectIcon)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// UI setup
        uiSetUp()
        /// tableRegister
        tableRegister()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            // Call the completion block when view is disappearing (dismissed)
            onDismiss?()
        }
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//            if viewController == self {
//                hidesBottomBarWhenPushed = false
//            }
//        }
    /// Table Register
    func tableRegister() {
        tbvChainType.delegate = self
        tbvChainType.dataSource = self
        tbvChainType.register(WalletConnectPopupTbvCell.nib, forCellReuseIdentifier: WalletConnectPopupTbvCell.reuseIdentifier)
    }
    func setupInitialState() {
        WalletKit.instance.sessionProposalExpirationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] proposal in
            guard let self = self else { return }
            if proposal.id == self.sessionProposal.id {
                dismiss(animated: true)
            }
        }.store(in: &disposeBag)

        WalletKit.instance.pairingExpirationPublisher
            .receive(on: DispatchQueue.main)
            .sink {[weak self]  pairing in
                if self?.sessionProposal.pairingTopic == pairing.topic {
                    
                    self?.dismiss(animated: true)
                }
        }.store(in: &disposeBag)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    // cancel button Action
    @IBAction func btnCancleAction(_ sender: Any) {
        onDismiss?()
        self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
       
    }
    // connect button Action
    @IBAction func btnConnectAction(_ sender: Any) {
        Task {
            try await self.onApprove()
        }
        
    }
    /// Session onApprove
    @MainActor
    func onApprove() async throws {
        do {
            let showConnected = try await interactor.approve(proposal: sessionProposal, EOAAccount: importAccount.account)
            if showConnected {
                let settingsVc = SettingsViewController(importAccount: importAccount)
                
                DispatchQueue.main.async { [weak self] in
                    self?.onDismiss?()
                    self?.navigationController?.pushViewController(settingsVc, animated: true)
                    
                    //   self.navigationController?.popViewController(animated: true)
                    
                    //self.dismiss(animated: true)
                    self?.dismiss(animated: true) {
                        self?.tabBarController?.selectedIndex = 1
                        //                    self.navigationController?.hidesBottomBarWhenPushed = false
                        UserDefaults.standard.set(true, forKey: "isConnected")
                        //                   let settingsVc = SettingsViewController()
                        //                    self.navigationController?.pushViewController(settingsVc, animated: true)
                        
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
                
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.showToast(message: "Not Approved", font:AppFont.regular(15).value)
                }
            }
        } catch {
            errorMessage = error.localizedDescription
          //  showError.toggle()
           // self.showToast(message: errorMessage, font:AppFont.regular(15).value)
           
        }
    }
    
    /// Session Reject
    @MainActor
    func onReject() async throws {
        do {
            try await interactor.reject(proposal: sessionProposal)
            DispatchQueue.main.async { [weak self] in
                self?.dismiss(animated: true)
                self?.onDismiss?()
                self?.navigationController?.hidesBottomBarWhenPushed = false
                self?.navigationController?.popViewController(animated: true)
            }
        } catch {
            errorMessage = error.localizedDescription
           // showError.toggle()
            DispatchQueue.main.async { [weak self] in
                self?.showToast(message: error.localizedDescription, font:AppFont.regular(15).value)
            }
            
        }
    }
}
//var importAccount: ImportAccount? {
//    get {
//        guard let value = UserDefaults.standard.string(forKey: "account") else {
//            return nil
//        }
//        guard let account = ImportAccount(input: value) else {
//            // Migration
//          importAccount = nil
//            return nil
//        }
//        return account
//    }
//    set {
//        UserDefaults.standard.set(newValue?.storageId, forKey: "account")
//    }
//}
