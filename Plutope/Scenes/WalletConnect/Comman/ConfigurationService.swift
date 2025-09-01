import UIKit
import WalletConnectNetworking
import WalletConnectNotify
import ReownWalletKit
import Combine
final class ConfigurationService {
    private var publishers = Set<AnyCancellable>()
    func configure(importAccount: ImportAccount) {
        Networking.configure(
            groupIdentifier: "group.com.plutoPe",
            projectId: InputConfig.projectId,
            socketFactory: DefaultSocketFactory()
        )
        Networking.instance.setLogging(level: .debug)

        let metadata = AppMetadata(
            name: "PlutoPe Wallet",
            description: "PlutoPe description",
            url: "https://www.plutope.io/",
            icons: ["https://plutope.app/api/images/applogo.png"], 
            redirect:try! AppMetadata.Redirect(native: "plutope://", universal: "https://presale.plutope.io/", linkMode: true)
        )

        WalletKit.configure(metadata: metadata, crypto: DefaultCryptoProvider(), environment: BuildConfiguration.shared.apnsEnvironment)

        Notify.configure(
            environment: BuildConfiguration.shared.apnsEnvironment,
            crypto: DefaultCryptoProvider()
        )

       

       
        Notify.instance.setLogging(level: .off)
        Sign.instance.setLogging(level: .debug)
        Events.instance.setLogging(level: .off)
        
        
        if let clientId = try? Networking.interactor.getClientId() {
            LoggingService.instance.setUpUser(account: importAccount.account.absoluteString, clientId: clientId)
            ProfilingService.instance.setUpProfiling(account: importAccount.account.absoluteString, clientId: clientId)
            let groupKeychain = GroupKeychainStorage(serviceIdentifier: "group.com.plutoPe")
            try! groupKeychain.add(clientId, forKey: "clientId")
        }
        Notify.instance.setLogging(level: .debug)
        WalletKit.instance.socketConnectionStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { status in
            switch status {
            case .connected:
                break
               // AlertPresenter.present(message: "Your web socket has connected", type: .success)
            case .disconnected:
                break
               // AlertPresenter.present(message: "Your web socket is disconnected", type: .warning)
            }
        }.store(in: &publishers)

        WalletKit.instance.logsPublisher
            .receive(on: DispatchQueue.main)
            .sink { log in
            switch log {
            case .error(let logMessage):
                break
             //   AlertPresenter.present(message: logMessage.message, type: .error)
            default: return
            }
        }.store(in: &publishers)

        WalletKit.instance.pairingExpirationPublisher
            .receive(on: DispatchQueue.main)
            .sink { pairing in
           // AlertPresenter.present(message: "Pairing has expired", type: .warning)
        }.store(in: &publishers)

        WalletKit.instance.sessionProposalExpirationPublisher.sink { _ in
           // AlertPresenter.present(message: "Session Proposal has expired", type: .warning)
        }.store(in: &publishers)

        WalletKit.instance.requestExpirationPublisher.sink { _ in
         //   AlertPresenter.present(message: "Session Request has expired", type: .warning)
        }.store(in: &publishers)

        Task {
            do {
               // let params = try await Notify.instance.prepareRegistration(account: importAccount.account, domain: "com.walletconnect")
               // let signature = importAccount.onSign(message: params.message)
//                try await Notify.instance.register(params: params, signature: signature)
            } catch {
                DispatchQueue.main.async {
                    let logMessage = LogMessage(message: "Push Server registration failed with: \(error.localizedDescription)")
                    ProfilingService.instance.send(logMessage: logMessage)
                    //UIApplication.currentWindow.rootViewController?
                     //   .showSimpleAlert(Message: "Register error")
                }
            }
        }
    }
}
