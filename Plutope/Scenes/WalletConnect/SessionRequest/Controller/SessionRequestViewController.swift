//
//  SessionRequestViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 13/02/24.
//

import UIKit
import Web3Wallet
class SessionRequestViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAssets: UILabel!
    @IBOutlet weak var lblFromAddress: UILabel!
    @IBOutlet weak var lblDapp: UILabel!
    @IBOutlet weak var lblToAddress: UILabel!
    @IBOutlet weak var lblAssetsText: UILabel!
    @IBOutlet weak var lblDappText: UILabel!
    @IBOutlet weak var lblToText: UILabel!
    @IBOutlet weak var lblFromText: UILabel!
    @IBOutlet weak var btnConfirm: GradientButton!
    @IBOutlet weak var btnCancel: UIButton!
    var errorMessage = "Error"
    var coinDetail: Token?
    private let interactor: SessionRequestInteractor
    let sessionRequest: Request
    let session: Session?
    let importAccount: ImportAccount
    var chainsArray = [String]()
    init(
        interactor: SessionRequestInteractor,
        sessionRequest: Request,importAccount: ImportAccount? = nil
    ) {
        defer { setupInitialState() }
        self.interactor = interactor
        self.sessionRequest = sessionRequest
        self.importAccount = importAccount ?? ImportAccount.new()
        self.session = interactor.getSession(topic: sessionRequest.topic)
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var message: String {
        let message = try? sessionRequest.params.get([String].self)
        let decryptedMessage = message.map { String(data: Data(hex: $0.first ?? ""), encoding: .utf8) }
        return (decryptedMessage ?? String(describing: sessionRequest.params.value)) ?? String(describing: sessionRequest.params.value)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // uiSetUp
        uiSetUp()
     
        print(session?.accounts)
        print(session?.namespaces)
        if let chains = session?.requiredNamespaces["eip155"]?.chains {
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
    
        let chainId = sessionRequest.chainId.absoluteString
        for chain in chainsArray {
            switch chain {
            case "eip155:56":
                lblAssets.text = "\(Chain.binanceSmartChain.name)(\(Chain.binanceSmartChain.symbol))"
            case "eip155:1":
                lblAssets.text = "\(Chain.ethereum.name)(\(Chain.ethereum.symbol))"
            case "eip155:137":
                lblAssets.text = "\(Chain.polygon.name)(\(Chain.polygon.symbol))"
            case "eip155:66":
                lblAssets.text = "\(Chain.oKC.name)(\(Chain.oKC.symbol))"
            default:
                break
            }
        }
        var to = ""
        if let jsonArray = sessionRequest.params.value as? [[String: Any]] {
            for var item in jsonArray {
                for (key, value) in item {
                    if let hexString = value as? String, key != "to" {
                        if let intValue = Int(hexString.replacingOccurrences(of: "0x", with: ""), radix: 16) {
                            item[key] = intValue
                        }
                    }
                }
                print(item)
                to = item["to"] as? String ?? ""
            }
        }
        lblDapp.text = session?.peer.name
        lblToAddress.text = to
        lblFromAddress.text = WalletData.shared.myWallet?.address
        lblEmail.text = message
        
        self.mainView.addTapGesture {
            self.dismiss()
        }
        // Do any additional setup after loading the view.
    }
    fileprivate func uiSetUp() {
        self.btnConfirm.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirm, comment: ""), for: .normal)
        self.btnCancel.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cancel, comment: ""), for: .normal)
        self.lblAssetsText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.asset, comment: "")
        self.lblFromText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.from, comment: "")
        self.lblToText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.to, comment: "")
      
        self.lblDapp.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.dApp, comment: "")
        self.lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.signatureRequest, comment: "")
        
    }
    @IBAction func btnCancelAction(_ sender: Any) {
        Task {
         try await self.onReject()
        }
    }
    @IBAction func btnConfirmAction(_ sender: Any) {
        Task {
         try await self.onApprove()
        }
    }
    func setupInitialState() {}
    
    @MainActor
    func onApprove() async throws {
        do {
            let showConnected = try await interactor.approve(sessionRequest: sessionRequest, importAccount: importAccount)
            if showConnected {
                self.dismiss(animated: true)
            } else {
                self.showToast(message: "Not Approved", font:AppFont.medium(15).value)
                self.dismiss(animated: true)
            }
        } catch {
            errorMessage = error.localizedDescription
            self.showToast(message: errorMessage, font:AppFont.medium(15).value)
            self.dismiss(animated: true)
            
        }
    }

    @MainActor
    func onReject() async throws {
        try await interactor.reject(sessionRequest: sessionRequest)
        self.dismiss(animated: true)
    }
    
    func dismiss() {
        self.dismiss(animated: true)
    }
}
