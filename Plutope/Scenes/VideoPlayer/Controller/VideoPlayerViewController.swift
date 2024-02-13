//
//  VideoPlayerViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 28/07/23.
//

import UIKit
import AVKit

class VideoPlayerViewController: UIViewController {
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var notificationToken: Any?
    var isPlayingInBackground = false
    var didFinishPlayback = false
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        playVideo()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
     
        player = nil
    }
    
    func playVideo() {
        guard let videoPath = Bundle.main.path(forResource: "Splash", ofType: "mp4") else { return }
        let videoPlayer = AVPlayer(url: URL(fileURLWithPath: videoPath))
        player = videoPlayer
        
        // create instance of playerlayer with videoPlayer
        let playerLayer = AVPlayerLayer(player: videoPlayer)
        // set its videoGravity to AVLayerVideoGravityResizeAspectFill to make it full size
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        // add it to your view
        playerLayer.frame = self.view.frame
        self.view.layer.addSublayer(playerLayer)
        
        // start playing video
        videoPlayer.play()
    }
    
    // navigateToNextScreen
    func navigateToNextScreen() {
        guard let appDelegate = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.delegate as? SceneDelegate,
              let window = appDelegate.window else {
            return
        }
        
        if UserDefaults.standard.object(forKey: DefaultsKey.appPasscode) != nil {
            AppPasscodeHelper().handleAppPasscodeIfNeeded(in: self) { status in
                if status {
                    self.transitionToAppropriateScreen(using: window)
                }
            }
        } else {
            self.transitionToAppropriateScreen(using: window)
        }
    }
    
    /// transitionToAppropriateScreen
    private func transitionToAppropriateScreen(using window: UIWindow) {
        let walletStoryboard = UIStoryboard(name: "WalletRoot", bundle: nil)
        
        if UserDefaults.standard.string(forKey: DefaultsKey.mnemonic) == nil {
            let walletSetUpVC = WalletSetUpViewController()
            let navigationController = UINavigationController(rootViewController: walletSetUpVC)
            navigationController.setNavigationBarHidden(true, animated: false)
            window.rootViewController = navigationController
        } else if let tabBarVC = walletStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
            window.rootViewController = tabBarVC
        }
        
        window.makeKeyAndVisible()
        UserDefaults.standard.set(true, forKey: DefaultsKey.splashVideoPlayed)
    }
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        notificationToken = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { [weak self] _ in
            // Check if navigation should be performed
            if !(self?.didFinishPlayback ?? false) {
                self?.didFinishPlayback = true
                self?.navigateToNextScreen()
            }
        }
    }
    
    @objc func willResignActive() {
        // The app is about to resign active (e.g., goes into the background or screen is resigned)
        // You can choose to pause the video or continue playing based on your requirement
        // For this case, let's pause the video
        
        // Pause the video if it's playing
        player?.pause()
        
        // Set isPlayingInBackground flag to true to indicate that the app is in the background or resigned
        isPlayingInBackground = true
    }
    
    @objc func didBecomeActive() {
        // The app became active again, resume video playback if it was playing before entering the background
        if isPlayingInBackground {
            player?.play()
            isPlayingInBackground = false
        }
    }
    
    deinit {
        // Remove the notification observers to avoid memory leaks
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        
        // Remove the notification observer for AVPlayerItemDidPlayToEndTimeNotification
        if let token = notificationToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
}
