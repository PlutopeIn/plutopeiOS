//
//  CardViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 12/06/23.
//
import UIKit
import Lottie

class CardViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tbvTransactions: UITableView!
    @IBOutlet weak var constantTbvHeight: NSLayoutConstraint!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnGetCard: UIButton!
    @IBOutlet weak var animationView: LottieAnimationView!
    
    var isPushed = false
    
    var arrTransactionData: [TransactionData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation header
       
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.card, comment: ""), btnBackHidden: true)
        self.btnGetCard.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.getcard, comment: ""), for: .normal)
            
        /// Table Register
        tableRegister()
        
        /// Long tap Action
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapped))
        btnHome.addGestureRecognizer(longTapGesture)
        
        // coming soon animation
        animationView.play()
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.5
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(forName: Notification.Name("LanguageDidChange"), object: nil, queue: .main) { (notification) in
            (self.headerView.subviews.first as? NavigationView)?.lblTitle.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.card, comment: "")
        }
        animationView.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animationView.stop()
    }
    
    /// Selector method
    @objc func longTapped() {
        
        self.tabBarController?.selectedIndex = 1
 
    }
    
    /// Table Register
    func tableRegister() {
        tbvTransactions.delegate = self
        tbvTransactions.dataSource = self
        tbvTransactions.register(TransactionViewCell.nib, forCellReuseIdentifier: TransactionViewCell.reuseIdentifier)
        constantTbvHeight.constant = CGFloat(75 * arrTransactionData.count)
    }
    
    @IBAction func actionGetCard(_ sender: Any) {
        let emailAuthVC = EmailAuthViewController()
        emailAuthVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(emailAuthVC, animated: true)
    }
    
    @IBAction func actionHome(_ sender: Any) {
        
//        let viewToNavigate = CoinTransferPopUp()
//        viewToNavigate.delegate = self
//        viewToNavigate.modalTransitionStyle = .coverVertical
//        viewToNavigate.modalPresentationStyle = .overFullScreen
//        self.present(viewToNavigate, animated: true)
        self.tabBarController?.selectedIndex = 1
        
    }
}
// MARK: Dismiss presented screen and push forward
extension CardViewController: PushViewControllerDelegate {
    
    func pushViewController(_ controller: UIViewController) {
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
