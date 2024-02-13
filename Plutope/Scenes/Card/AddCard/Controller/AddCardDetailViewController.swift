//
//  AddCardDetailViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 01/08/23.
//

import UIKit
import ABSteppedProgressBar

class AddCardDetailViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var progressBar: ABSteppedProgressBar!
    @IBOutlet weak var detailView: UIView!
    
    internal let subtitleHeight: CGFloat = 30
    internal let subtitleFontSize: CGFloat = 12
    
    var personalInfoVC: PersonalInfoViewController = PersonalInfoViewController()
    var addAddressVC: AddAddressViewController = AddAddressViewController()
    var moreDetailVC: MoreDetailViewController = MoreDetailViewController()
    var membershipDetailVC: MembershipPlanViewController = MembershipPlanViewController()
    var membershipCardDesignVC :MembershipCardDesignViewController = MembershipCardDesignViewController()
    var cardDesignVC:CardDesignViewController = CardDesignViewController()
    var cardPaymentVC:CardPaymentViewController = CardPaymentViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// Configure header
        defineHeader(headerView: headerView, titleText: "", btnBackAction: {
            self.handleBackButtonAction()
        })
        
        /// Configure progress bar
        self.configureProgressBar()
        
        /// Dispatch in order to render the subtitle in the next runloop
        DispatchQueue.main.async {
            self.addSubtitles()
        }
        
        /// Add the PersonalInfoViewController as a child view controller
        addChild(personalInfoVC)
        detailView.addNibView(nibView: personalInfoVC.view)
        personalInfoVC.didMove(toParent: self)
        
        setupChildViewControllers()

    }
}

// MARK: - Set Up Child views
extension AddCardDetailViewController {
    
    // MARK: Set Up Child View Controllers on tap
    func setupChildViewControllers() {
        /// Personal Details
        personalInfoVC.onNextButtonTapped = {
            self.addChild(self.addAddressVC)
            self.detailView.addNibView(nibView: self.addAddressVC.view)
            self.addAddressVC.didMove(toParent: self)
        }
        
        addAddressVC.onNextButtonTapped = {
            self.addChild(self.moreDetailVC)
            self.detailView.addNibView(nibView: self.moreDetailVC.view)
            self.moreDetailVC.didMove(toParent: self)
        }
        
        moreDetailVC.onNextButtonTapped = {
            self.addChild(self.membershipDetailVC)
            self.detailView.addNibView(nibView: self.membershipDetailVC.view)
            self.membershipDetailVC.didMove(toParent: self)
            self.progressBar.currentIndex = Step.membership.rawValue
        }
        
        /// Membership Details
        membershipDetailVC.onNextButtonTapped = {  data in
            
            self.addChild(self.membershipCardDesignVC)
            self.membershipCardDesignVC.receivedPlanPrice = data
            self.detailView.addNibView(nibView: self.membershipCardDesignVC.view)
            self.membershipCardDesignVC.didMove(toParent: self)
            
        }
        
        membershipCardDesignVC.onNextButtonTapped = {  data in
            self.addChild(self.cardDesignVC)
            self.cardDesignVC.receivedPlanPrice = data
            self.detailView.addNibView(nibView: self.cardDesignVC.view)
            self.cardDesignVC.didMove(toParent: self)
            self.progressBar.currentIndex = Step.card.rawValue
        }
        
        /// Card Details
        cardDesignVC.onNextButtonTapped = {   data in
            self.addChild(self.cardPaymentVC)
            self.cardPaymentVC.receivedPlanPrice = data
            self.detailView.addNibView(nibView: self.cardPaymentVC.view)
            self.cardDesignVC.didMove(toParent: self)
            self.progressBar.currentIndex = Step.payment.rawValue
        }
        
        // TODO: Handle payment details redirection actions here
    }
    
}

// MARK: Remove subviews
extension AddCardDetailViewController {
    
    // MARK: Handle Back button action
    private func handleBackButtonAction() {
        if let moreDetailView = self.detailView.subviews.first(where: { $0 == self.cardPaymentVC.view }) {
            
            removeChildViewController(self.cardPaymentVC)
            self.progressBar.currentIndex = Step.card.rawValue
            
        } else if let moreDetailView = self.detailView.subviews.first(where: { $0 == self.cardDesignVC.view }) {
            
            removeChildViewController(self.cardDesignVC)
            self.progressBar.currentIndex = Step.membership.rawValue
            
        } else if let moreDetailView = self.detailView.subviews.first(where: { $0 == self.membershipCardDesignVC.view }) {
            
            removeChildViewController(self.membershipCardDesignVC)
            self.progressBar.currentIndex = Step.membership.rawValue
            
        } else if let moreDetailView = self.detailView.subviews.first(where: { $0 == self.membershipDetailVC.view }) {
            
            removeChildViewController(self.membershipDetailVC)
            self.progressBar.currentIndex = Step.personalDetails.rawValue
            
        } else if let moreDetailView = self.detailView.subviews.first(where: { $0 == self.moreDetailVC.view }) {
            
            removeChildViewController(self.moreDetailVC)
            self.progressBar.currentIndex = Step.personalDetails.rawValue
            
        } else if let addressView = self.detailView.subviews.first(where: { $0 == self.addAddressVC.view }) {
            
            removeChildViewController(self.addAddressVC)
            self.progressBar.currentIndex = Step.personalDetails.rawValue
            
        } else if let addressView = self.detailView.subviews.first(where: { $0 == self.personalInfoVC.view }) {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
}
