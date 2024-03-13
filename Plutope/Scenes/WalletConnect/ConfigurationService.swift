import UIKit
import WalletConnectNetworking
import WalletConnectNotify
import Web3Wallet

final class ConfigurationService {

    func configure(importAccount: ImportAccount) {
        Networking.configure(
            groupIdentifier: "group.com.plutoPe",
            projectId: Secrets.load().projectID,
            socketFactory: WalletConnectSocketClientFactory()
        )
        Networking.instance.setLogging(level: .debug)

        let metadata = AppMetadata(
            name: "PlutoPe Wallet",
            description: "PlutoPe description",
            url: "https://react-app.walletconnect.com/",
            icons: ["https://plutope.app/api/images/applogo.png"], 
            redirect: AppMetadata.Redirect(native: "plutope://", universal: nil)
        )

        Web3Wallet.configure(metadata: metadata, crypto: DefaultCryptoProvider(), environment: BuildConfiguration.shared.apnsEnvironment)

        Notify.configure(
            environment: BuildConfiguration.shared.apnsEnvironment,
            crypto: DefaultCryptoProvider()
        )

        Notify.instance.setLogging(level: .debug)

        if let clientId = try? Networking.interactor.getClientId() {
            LoggingService.instance.setUpUser(account: importAccount.account.absoluteString, clientId: clientId)
//            ProfilingService.instance.setUpProfiling(account: importAccount.account.absoluteString, clientId: clientId)
        }
        LoggingService.instance.startLogging()
    
//        Task {
//            do {
//                let deviceToken = UserDefaults.standard.value(forKey: "fcm_Token") as? String ?? ""
//                let params = try await Notify.instance.prepareRegistration(account: importAccount.account, domain: "com.walletconnect")
//                let signature = importAccount.onSign(message: params.message)
//                try await Notify.instance.register(params: params, signature: signature)
////                try await Notify.instance.register(account: importAccount.account, domain: "com.walletconnect", onSign: importAccount.onSign)
//            } catch {
//                DispatchQueue.main.async {
//                    let logMessage = LogMessage(message: "Push Server registration failed with: \(error.localizedDescription)")
//                  //  ProfilingService.instance.send(logMessage: logMessage)
//                  //  UIApplication.currentWindow.rootViewController?.showAlert(title: "Register error", error: error)
//                }
//            }
//        }

    }
}
