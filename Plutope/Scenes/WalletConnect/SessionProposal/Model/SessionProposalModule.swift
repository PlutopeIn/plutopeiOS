import SwiftUI
//import WalletConnectSign
import ReownWalletKit

final class SessionProposalModule {

    @discardableResult
    static func create(
        app: Application,
        importAccount: ImportAccount,
        proposal: Session.Proposal,
        context: VerifyContext?
    ) -> UIViewController {
        let interactor = SessionProposalInteractor()
        let viewController = DAppConnectPopupViewController(interactor: interactor, importAccount: importAccount, proposal: proposal, context: context)
        return viewController
    }
}
