//
//  DAppConnectPopupViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 08/01/23.
//

import UIKit
import AVFoundation
import Web3Wallet
import WalletConnectRouter
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
    var coinDetail: Token?
    private let interactor: SessionProposalInteractor
    let importAccount: ImportAccount
    let sessionProposal: Session.Proposal
    let validationStatus: VerifyContext.ValidationStatus?
    var chainsArray = [String]()
    
    private var disposeBag = Set<AnyCancellable>()
    let app: Application
    init(
        interactor: SessionProposalInteractor? = nil,
        importAccount: ImportAccount? = nil,
        proposal: Session.Proposal,
        context: VerifyContext? = nil,
        app: Application? = nil
    ) {
        defer { setupInitialState() }
        self.app = app ?? Application()
        self.interactor = interactor ?? SessionProposalInteractor()
        self.sessionProposal = proposal
        self.importAccount = importAccount ?? ImportAccount.new()
        self.validationStatus = context?.validation
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var allNamespaces: [SessionNamespace] = []
    fileprivate func uiSetUp() {
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = 18
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        var combinedChains = Set<Blockchain>()
//
//        if let requiredChains = sessionProposal.requiredNamespaces["eip155"]?.chains {
//            combinedChains.formUnion(requiredChains)
//        }
//
//        if let optionalChains = sessionProposal.optionalNamespaces?["eip155"]?.chains {
//            combinedChains.formUnion(optionalChains)
//        }
//
//        // Convert combinedChains to an array of Blockchain objects
//        var chainsArray: [String] = combinedChains.compactMap { element in
//            guard let val = element as? Blockchain else { return nil }
//            return val.absoluteString
//        }
//        // Append the elements to chainsArray
//        self.chainsArray.append(contentsOf: chainsArray)
       
        if let chains = sessionProposal.requiredNamespaces["eip155"]?.chains {
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
        lblDappName.text = "Exchange | \(sessionProposal.proposer.name) wants to connect to your wallet"
        lblUrl.text = "\(sessionProposal.proposer.url)"
        // Create URL
        ivDapp.sd_setImage(with: URL(string: "\(sessionProposal.proposer.icons)"), placeholderImage: UIImage.icwalletConnectIcon)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// tableRegister
        tableRegister()
        /// UI setup
        uiSetUp()
        
    }
    /// Table Register
    func tableRegister() {
        tbvChainType.delegate = self
        tbvChainType.dataSource = self
        tbvChainType.register(WalletConnectPopupTbvCell.nib, forCellReuseIdentifier: WalletConnectPopupTbvCell.reuseIdentifier)
    }
    func setupInitialState() {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    // cancel button Action
    @IBAction func btnCancleAction(_ sender: Any) {
        self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    // connect button Action
    @IBAction func btnConnectAction(_ sender: Any) {
        do {
            Task {
                try await self.onApprove()
            }
        } catch {
            // Handle the error here
            print("Error: \(error)")
        }
        
    }
    /// Session onApprove
    @MainActor
    func onApprove() async throws {
        do {
            let showConnected = try await interactor.approve(proposal: sessionProposal, account: importAccount.account)
            if showConnected {
                self.dismiss(animated: true)
                self.navigationController?.popViewController(animated: true)
            } else {
                self.showToast(message: "Not Approved", font:AppFont.medium(15).value)
            }
        } catch {
            errorMessage = error.localizedDescription
            self.showToast(message: errorMessage, font:AppFont.medium(15).value)
           
        }
    }
    
    /// Session Reject
    @MainActor
    func onReject() async throws {
        do {
            try await interactor.reject(proposal: sessionProposal)
            self.dismiss(animated: true)
            self.navigationController?.popViewController(animated: true)
        } catch {
            errorMessage = error.localizedDescription
            self.showToast(message: errorMessage, font:AppFont.medium(15).value)
            
        }
    }
}
