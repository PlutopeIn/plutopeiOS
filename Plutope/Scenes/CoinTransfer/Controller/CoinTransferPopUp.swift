//
//  CoinTransferPopUp.swift
//  Plutope
//
//  Created by Priyanka Poojara on 12/06/23.
//
import UIKit
import Lottie

class CoinTransferPopUp: UIViewController, Reusable {
    
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var icCancel: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblSwap: UILabel!
    @IBOutlet weak var lblBuy: UILabel!
    @IBOutlet weak var lblSend: UILabel!
    @IBOutlet weak var lblReceive: UILabel!
    
    weak var delegate: PushViewControllerDelegate?
    let coinListVC = BuyCoinListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblBuy.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.buy, comment: "")
        self.lblSwap.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swap, comment: "")
        self.lblSend.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send, comment: "")
        self.lblReceive.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.receive, comment: "")
        
        self.icCancel.addTapGesture {
         //   self.dismiss(animated: true)
            self.dismiss(animated: true) {
               
//                guard let proto = self.delegate else {return}
//                //self.coinListVC.isFrom = .swap
//                self.tabBarController?.selectedIndex = 1
//                self.hidesBottomBarWhenPushed = false
//                proto.pushViewController(WalletDashboardViewController())
            }
           
        }
        
        self.coinListVC.hidesBottomBarWhenPushed = true
    }
    
    @IBAction func actionSwap(_ sender: Any) {
        self.dismiss(animated: true) {
            guard let proto = self.delegate else {return}
            self.coinListVC.isFrom = .swap
            proto.pushViewController(self.coinListVC)
        }
    }
    
    @IBAction func actionSend(_ sender: Any) {
        
        self.dismiss(animated: true) {
            guard let proto = self.delegate else {return}
            self.coinListVC.isFrom = .send
            proto.pushViewController(self.coinListVC)
        }
        
    }
    
    @IBAction func actionReceive(_ sender: Any) {
        self.dismiss(animated: true) {
            guard let proto = self.delegate else {return}
            self.coinListVC.isFrom = .receive
            proto.pushViewController(self.coinListVC)
        }
    }
    
    @IBAction func actionBuy(_ sender: Any) {
        self.dismiss(animated: true) {
            guard let proto = self.delegate else {return}
            self.coinListVC.isFrom = .buy
            proto.pushViewController(self.coinListVC)
        }
    }

    @IBAction func actionHome(_ sender: Any) {
        
    }
}
