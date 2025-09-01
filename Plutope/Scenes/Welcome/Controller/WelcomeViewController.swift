//
//  WelcomeViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 08/06/23.
//
import UIKit
import CoreData
import Lottie
class WelcomeViewController: UIViewController, Reusable {
    @IBOutlet weak var heightBtnNext: NSLayoutConstraint!
    
    @IBOutlet weak var heightPageCon: NSLayoutConstraint!
    @IBOutlet weak var lblNext: UILabel!
    @IBOutlet weak var lblSkip: UILabel!
    @IBOutlet weak var imgNext: UIImageView!
    @IBOutlet weak var viewNext: LottieAnimationView!
    @IBOutlet weak var clvWelcomeViews: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    /*var arrWelcome: [WelcomeData] = [
        WelcomeData(image: UIImage.cardGif, title: StringConstants.welcomeTitle1, description: StringConstants.welcomeDesc1, animation: "card"),
        WelcomeData(image: UIImage.welcome2, title: StringConstants.welcomeTitle2, description: StringConstants.welcomeDesc2, animation: "multichain"),
        WelcomeData(image: UIImage.welcome3, title: StringConstants.welcomeTitle3, description: StringConstants.welcomeDesc3, animation: "oneWallet1")
    ]*/
    var arrWelcome: [WelcomeData] = [
        /*WelcomeData(image: UIImage.cardGif, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.spendyourcryptoanywhereintheworldwithplutopedebitcard, comment: ""), description: StringConstants.welcomeDesc1, animation: "card"),
        WelcomeData(image: UIImage.welcome2, title: StringConstants.welcomeTitle2, description: StringConstants.welcomeDesc2, animation: "multichain"),
        WelcomeData(image: UIImage.welcome3, title: StringConstants.welcomeTitle3, description: StringConstants.welcomeDesc3, animation: "oneWallet1")*/
        
        WelcomeData(image: UIImage.welcomeScreen3, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.spendyourcryptoanywhereintheworld, comment: ""), description: StringConstants.welcomeDesc1),
        WelcomeData(image: UIImage.welcomeScreen1, title: StringConstants.welcomeTitle3, description: StringConstants.welcomeDesc3),
        WelcomeData(image: UIImage.welcomeScreen2, title: StringConstants.welcomeTitle3, description: StringConstants.welcomeDesc3)
        
        
    ]
    lazy var viewModel: TokenListViewModel = {
        TokenListViewModel { status,message in
            if status == false {
                self.showToast(message: message, font: AppFont.regular(15).value)
            }
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblSkip.font = AppFont.regular(16).value
        lblNext.font = AppFont.regular(14.97).value
        
        self.lblNext.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.getStared, comment: "")
        self.lblSkip.addTapGesture {
            /// Root redirection
//            guard let appDelegate = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.delegate as? SceneDelegate else { return }
//            let walletStoryboard = UIStoryboard(name: "WalletRoot", bundle: nil)
//            guard let tabBarVC =      walletStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController else { return }
//            appDelegate.window?.makeKeyAndVisible()
//            appDelegate.window?.rootViewController = tabBarVC
            guard let appDelegate = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.delegate as? SceneDelegate else { return }
                                  
                                  let tabBarVC = TabBarViewController(interactor: appDelegate.interactor, app: appDelegate.app, configurationService: appDelegate.app.configurationService)
                                  window?.rootViewController = tabBarVC
                                  window?.makeKeyAndVisible()
        }
        self.imgNext.superview?.addTapGesture {
            HapticFeedback.generate(.light)
            let currentPage = self.pageControl.currentPage
            let nextPage = currentPage + 1
            
            // Check if next page is within bounds
            if nextPage < self.arrWelcome.count {
                let offsetX = CGFloat(nextPage) * self.clvWelcomeViews.frame.size.width
                self.clvWelcomeViews.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            }
        }
        
        /// Register Collection
        collectionRegister()
        
        /// API: Get Token/Coin Images
        getImagesFromAPi()
//        setupLottieAnimation()

        lblNext.addTapGesture {
            HapticFeedback.generate(.light)
            /// Root redirection
//            guard let appDelegate = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.delegate as? SceneDelegate else { return }
//            let walletStoryboard = UIStoryboard(name: "WalletRoot", bundle: nil)
//            guard let tabBarVC =      walletStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController else { return }
//            appDelegate.window?.makeKeyAndVisible()
//            appDelegate.window?.rootViewController = tabBarVC
            guard let appDelegate = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.delegate as? SceneDelegate else { return }
                                  
                                  let tabBarVC = TabBarViewController(interactor: appDelegate.interactor, app: appDelegate.app, configurationService: appDelegate.app.configurationService)
                                  window?.rootViewController = tabBarVC
                                  window?.makeKeyAndVisible()
        }
       
    }

//    private func setupLottieAnimation() {
//        if let jsonPath = Bundle.main.path(forResource: "next", ofType: "json") {
//            viewNext.animation = LottieAnimation.filepath(jsonPath)
//            viewNext.loopMode = .loop
//            viewNext.animationSpeed = 2
//            viewNext.play(completion: nil)
//            viewNext.contentMode = .scaleToFill
//        }
//    }
    // Pseudo-code for getImagesFromAPi function
    func getImagesFromAPi() {
        // Check if the 'Token' entity is not empty in the local database
        if !DatabaseHelper.shared.entityIsEmpty("Token") {
            guard let allToken = DatabaseHelper.shared.retrieveData("Token") as? [Token] else {
                return
            }
            
            // Call the API to get a list of images with a completion handler
            viewModel.apiGetTokenImagesFromApi { imageList, _, _ in
                // Handle API response or error (error handling omitted for brevity)
                
                // If there are images received from the API
                if let images = imageList {
                    // Perform image updates in the background to avoid blocking the main thread
                    var imageURLsByCoinID: [String: String] = [:]
                    for image in images {
                        if let id = image.coinID, let imageURL = image.image {
                            imageURLsByCoinID[id] = imageURL
                        }
                    }
                    
                    for token in allToken {
                        if token.tokenId == "PLT".lowercased() {
                            // Set static image URL for PLT
                            token.logoURI = "https://plutope.app/api/images/applogo.png"
                        } else if let id = token.tokenId, let imageURL = imageURLsByCoinID[id] {
                            // Update logoURI for other tokens using API data
                            token.logoURI = imageURL
                        }
                    }
                }
            }
        }
    }

    
    /// Register Collection
    func collectionRegister() {
        
        clvWelcomeViews.register(WelcomeViewCell.nib, forCellWithReuseIdentifier: WelcomeViewCell.reuseIdentifier)
        clvWelcomeViews.delegate = self
        clvWelcomeViews.dataSource = self
        
    }
    
}
