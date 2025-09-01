//
//  WalletConnectPopupViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 08/01/23.
//

import UIKit
import QRScanner
import AVFoundation
import WalletConnectSign
import WalletConnectUtils
//import Web3Wallet
import ReownWalletKit
import Web3
import Combine
import SafariServices

class WalletConnectPopupViewController: UIViewController {
    @IBOutlet weak var stackNoData: UIStackView!
    @IBOutlet weak var tbvSession: UITableView!
    @IBOutlet weak var tbvHeight: NSLayoutConstraint!
    @IBOutlet weak var btnConnectWallet: GradientButton!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var imgNoData: UIImageView!
    
    var isConnected = false
    var showPairingLoading = false
    var sessions = [Session]()
    let interactor: WalletInteractor
    let importAccount: ImportAccount
    private var disposeBag = Set<AnyCancellable>()
    private let app: Application
    init(
        interactor: WalletInteractor? = nil,
        app: Application? = nil,
        importAccount: ImportAccount
    ) {
        defer {
            setupInitialState()
        }
        self.interactor = interactor ?? WalletInteractor()
        self.app = app ?? Application()
        self.importAccount = importAccount
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func uiSetUp() {
        //btnConnectWallet.isHidden = true
        
        btnConnectWallet.titleLabel?.font = AppFont.regular(13).value
        lblNoData.font = AppFont.violetRegular(16).value
        lblNoData.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.noData, comment: "")
        btnConnectWallet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addNewConnection, comment: ""), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.walletConnect, comment: ""))
        /// Table Register
        tableRegister()
        
        uiSetUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  onAppear()
       // DispatchQueue.main.async {
        self.tbvSession.reloadData()
        self.tbvSession.restore()
        if sessions.isEmpty {
            stackNoData.isHidden = false
        } else {
            stackNoData.isHidden = true
        }
            
      //  }
    }
    private func setupInitialState() {
        interactor.sessionsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sessions in
                self?.sessions = sessions
                
                if sessions.count != 0 {
                    self?.imgNoData.isHidden = true
                    self?.lblNoData.isHidden = true
                } else {
                    self?.imgNoData.isHidden = false
                    self?.lblNoData.isHidden = false
                }
                
                DispatchQueue.main.async {
                    self?.tbvSession.reloadData()
                    self?.tbvSession.restore()
                }
                
            }
            .store(in: &disposeBag)
        
        sessions = interactor.getSessions()
        pairFromDapp()
    }
    
    private func pairFromDapp() {
        guard let url = app.uri else {
            return
        }
        
        pairClient(uri: url.absoluteString)
    }
    func onAppear() {
        showPairingLoading = app.requestSent
        let pendingRequests = interactor.getPendingRequests()
//        if let request = pendingRequests.first(where: { $0.context != nil }) {
//            SessionRequestModule.create(app: app, sessionRequest: request.request, importAccount: importAccount, sessionContext: request.context)
//                .presentFullScreen(from: self, transparentBackground: false)
//        }
    }
    
    func onConnection(session: Session) {
        ConnectionDetailsModule.create(app: app, session: session)
            .push(from: self)
    }
    
    /// Table Register
    func tableRegister() {
        tbvSession.delegate = self
        tbvSession.dataSource = self
        tbvSession.register(WalletConnectPopupTbvCell.nib, forCellReuseIdentifier: WalletConnectPopupTbvCell.reuseIdentifier)
    }
    /// pair to client
    func pairClient(uri: String) {
        print("[WALLET] Pairing to: \(uri)")
        guard let uri = WalletConnectURI(string: uri) else {
            return
        }
        Task {
            do { self.showPairingLoading = true
                try await WalletKit.instance.pair(uri: uri)
                
            } catch {
                self.showPairingLoading = false
                print("[DAPP] Pairing connect error: \(error)")
            }
        }
    }
    // open QRCode Scanner
    @IBAction func btnConnectWalletAction(_ sender: Any) {
        HapticFeedback.generate(.light)
//        let url = "https://webview-dev.rampable.co/?clientSecret=wpyYO6EyVSwx3QGY50d0VHCICTjiBHTTRGo7zbL6G6bxBtCSaGBrEbRB70ZhzdvP&useWalletConnect=true"
//        self.showWebView(for: url, onVC: self, title: "")
        DispatchQueue.main.async {
            let scanner = QRScannerViewController()
            scanner.delegate = self
            self.present(scanner, animated: true, completion: nil)
        }
    }
    
    //    checkForCameraPermission
    func checkForCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            break
        case .denied:
            showCameraSettingsAlert()
        case .restricted:
            break
        default: break
        }
    }
    
    //    showCameraSettingsAlert
    func showCameraSettingsAlert() {
        let alert = UIAlertController(title: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cameraAccessDenied, comment: ""))", message: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cameraAccess, comment: ""))", preferredStyle: .alert)
        
        // Add an action to open the app's settings
        alert.addAction(UIAlertAction(title: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.openSetting, comment: ""))", style: .default, handler: { action in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }))
        
        // Add a cancel action
        alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cancel, comment: ""), style: .cancel, handler: nil))
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    @MainActor
    func showWebView(for url: String, onVC: UIViewController, title: String) {
        
        let webController = WebViewController()
        webController.webViewURL = url
        webController.webViewTitle = title
        webController.isFrom = "coinDetail"
        let navVC = UINavigationController(rootViewController: webController)
        navVC.modalPresentationStyle = .overFullScreen
        navVC.modalTransitionStyle = .crossDissolve
        onVC.present(navVC, animated: true)
        }
    
}
// MARK: QRScannerDelegate
extension WalletConnectPopupViewController: QRScannerDelegate {
    func qrScannerDidFail(scanner: QRScanner.QRScannerViewController, error: QRScanner.QRScannerError) {
        
    }
    
    func qrScannerDidSuccess(scanner: QRScanner.QRScannerViewController, result: String) {
        scanner.dismiss(animated: true) {
            let urlString = result
            print(result)
            self.pairClient(uri: urlString)
        }
    }
}
