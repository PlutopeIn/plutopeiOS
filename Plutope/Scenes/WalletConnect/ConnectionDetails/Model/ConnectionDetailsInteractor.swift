import Combine

import ReownWalletKit

final class ConnectionDetailsInteractor {
//    var requestPublisher: AnyPublisher<(request: AuthRequest, context: VerifyContext?), Never> {
//        return WalletKit.instance.authRequestPublisher
//    }
        func pair(uri: WalletConnectURI) async throws {
        try await WalletKit.instance.pair(uri: uri)
    }
    
    func disconnectSession(session: Session) async throws {
        try await WalletKit.instance.disconnect(topic: session.topic)
    }
}
