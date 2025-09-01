import Foundation

//import Web3Wallet
import ReownWalletKit
 import ReownRouter

final class SessionRequestInteractor {
    func approve(sessionRequest: Request, importAccount: ImportAccount) async throws -> Bool {
        do {
            let result = try Signer.sign(request: sessionRequest, importAccount: importAccount)
            try await WalletKit.instance.respond(
                topic: sessionRequest.topic,
                requestId: sessionRequest.id,
                response: .response(result)
            )
            
            /* Redirect */
            let session = getSession(topic: sessionRequest.topic)
            if let uri = session?.peer.redirect?.native {
                ReownRouter.goBack(uri: uri)
                return false
            } else {
                return true
            }
        } catch {
            throw error
        }
    }

    func reject(sessionRequest: Request) async throws {
        try await WalletKit.instance.respond(
            topic: sessionRequest.topic,
            requestId: sessionRequest.id,
            response: .error(.init(code: 0, message: ""))
        )
        
        /* Redirect */
        let session = getSession(topic: sessionRequest.topic)
        if let uri = session?.peer.redirect?.native {
            ReownRouter.goBack(uri: uri)
        }
    }

    func getSession(topic: String) -> Session? {
        return WalletKit.instance.getSessions().first(where: { $0.topic == topic })
    }
}
