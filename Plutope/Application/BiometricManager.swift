//
//  BiometricManager.swift
//  Plutope
//
//  Created by Priyanka Poojara on 06/07/23.
//

import UIKit
import LocalAuthentication

// MARK: AppPasscodeHelper
class AppPasscodeHelper: PasscodeVerifyDelegate {
    
    lazy var passcodeVC: CreatePasscodeViewController? = nil
    var isVerify: Bool = false
    lazy var completion: ((Bool) -> Void)? = nil
  
    func verifyPasscode(isVerify: Bool) {
        if isVerify {
            passcodeVC?.dismiss(animated: true) {
                self.isVerify = true
                self.performActionAfterAuthentication(completion: self.completion)
            }
        } else {
            self.isVerify = false
        }
    }
    
    func handleAppPasscodeIfNeeded(in viewController: UIViewController, completion: ((Bool) -> Void)? = nil) {
        self.completion = completion // Assign the global completion closure
        
        if UserDefaults.standard.object(forKey: DefaultsKey.appPasscode) != nil && UserDefaults.standard.string(forKey: DefaultsKey.appLockMethod) == "Passcode/Touch ID/Face ID" {
            DispatchQueue.main.async {
                self.openPasscodeViewController(in: viewController) { isVerify in
                    if isVerify {
                        self.performActionAfterAuthentication(completion: completion)
                    } else {
                        completion?(false)
                    }
                }
            }
            
            BiometricAuthenticationManager.shared.authenticateWithBiometrics { status, error in
                DispatchQueue.main.async {
                    if status {
                        if let rootVc = viewController.view.window?.rootViewController?.presentedViewController as? CreatePasscodeViewController {
                            rootVc.dismiss(animated: true) {
                                self.isVerify = true
                                self.performActionAfterAuthentication(completion: completion)
                            }
                        }
                    } else {
                        print(error?.localizedDescription ?? "")
                        completion?(false)
                    }
                }
            }
        } else if UserDefaults.standard.object(forKey: DefaultsKey.appPasscode) != nil {
            DispatchQueue.main.async {
                self.openPasscodeViewController(in: viewController) { isVerify in
                    if isVerify {
                        self.performActionAfterAuthentication(completion: completion)
                    } else {
                        completion?(false)
                    }
                }
            }
        }
    }
    
    func openPasscodeViewController(in viewController: UIViewController, completion: @escaping (Bool) -> Void) {
        passcodeVC = CreatePasscodeViewController()
        passcodeVC?.isEnterPasscode = true
        passcodeVC?.isFrom = "Biometric"
        passcodeVC?.modalTransitionStyle = .crossDissolve
        passcodeVC?.modalPresentationStyle = .overFullScreen
        passcodeVC?.verifyPassDelegate = self
        if viewController.presentedViewController is CreatePasscodeViewController {
            // Passcode view controller is already presented, no need to present it again
            return
        } else {
            viewController.present(passcodeVC ?? CreatePasscodeViewController(), animated: true) {
                completion(self.isVerify)
            }
        }
    }
    
    func performActionAfterAuthentication(completion: ((Bool) -> Void)?) {
        // Perform the desired action after successful authentication
        print("Authentication successful! Perform the action here.")
        completion?(true)
    }
}

class BiometricAuthenticationManager {
    static let shared = BiometricAuthenticationManager()
    private init() {}
    
    func authenticateWithBiometrics(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        // Check if the device supports biometric authentication
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate using biometrics"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                DispatchQueue.main.async {
                    if success {
                        // Biometric authentication succeeded
                        completion(true, nil)
                    } else if let error = error {
                        // Biometric authentication failed
                        completion(false, error)
                    }
                }
            }
        } else {
            // Device does not support biometric authentication
            completion(false, error)
        }
    }
}
