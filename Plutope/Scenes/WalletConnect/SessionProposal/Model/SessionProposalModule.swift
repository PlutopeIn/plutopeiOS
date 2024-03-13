import SwiftUI

import Web3Wallet

final class SessionProposalModule {

    @discardableResult
    static func create(
        app: Application,
        importAccount: ImportAccount,
        proposal: Session.Proposal,
        context: VerifyContext?
    ) -> UIViewController {
        let interactor = SessionProposalInteractor()
        let viewController = DAppConnectPopupViewController(proposal: proposal)
        return viewController
    }
}

