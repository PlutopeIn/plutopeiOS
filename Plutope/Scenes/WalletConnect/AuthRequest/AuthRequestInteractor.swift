//import Foundation
//
//import ReownWalletKit
//import ReownRouter
//
//final class AuthRequestInteractor {
//
//    private let messageSigner: MessageSigner
//
//    init(messageSigner: MessageSigner) {
//        self.messageSigner = messageSigner
//    }
//
//    
//    func approve(request: AuthRequest, importAccount: ImportAccount) async throws -> Bool {
//        let account = importAccount.account
//        let signature = try messageSigner.sign(
//            payload: request.payload.cacaoPayload(address: account.address),
//            privateKey: Data(hex: importAccount.privateKey),
//            type: .eip191)
//        try await Web3Wallet.instance.respond(requestId: request.id, signature: signature, from: account)
//        
//        /* Redirect */
//        if let uri = request.requester.redirect?.native {
//            ReownRouter.goBack(uri: uri)
//            return false
//        } else {
//            return true
//        }
//    }
//
//    func reject(request: AuthRequest) async throws {
//        try await WalletKit.instance.reject(requestId: request.id)
//
//        /* Redirect */
//        if let uri = request.requester.redirect?.native {
//            ReownRouter.goBack(uri: uri)
//        }
//    }
//
//    func formatted(request: AuthRequest, account: Account) -> String {
//        return try! WalletKit.instance.formatMessage(
//            payload: request.payload,
//            address: account.address
//        )
//    }
//}
