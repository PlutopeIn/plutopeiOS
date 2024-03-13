import SwiftUI

import Web3Wallet

final class ConnectionDetailsModule {
    @discardableResult
    static func create(app: Application, session: Session) -> UIViewController {
        let interactor = ConnectionDetailsInteractor()
        let viewController = WalletConnectionDetailPopup(interactor: interactor,session: session)
        return viewController
    }
    
}
