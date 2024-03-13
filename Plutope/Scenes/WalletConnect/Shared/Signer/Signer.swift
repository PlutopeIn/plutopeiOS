import Foundation
import Commons
import WalletConnectSign


final class Signer {
    enum Errors: Error {
        case notImplemented
    }

    private init() {}
    
    static func sign(request: Request, importAccount: ImportAccount) throws -> AnyCodable {
        var signer = ETHSigner(importAccount: importAccount)

        
        switch request.method {
        case "personal_sign":
            return signer.personalSign(request.params)
        case "eth_signTransaction" :
            return signer.personalSign(request.params)
        case "eth_signTypedData":
            return signer.signTypedData(request.params)

        case "eth_sendTransaction":
            print(request)
             
            return try signer.sendTransaction(request)

        case "solana_signTransaction":
            return SOLSigner.signTransaction(request.params)
            
        default:
            throw Signer.Errors.notImplemented
        }
    }
}

extension Signer.Errors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notImplemented:   return "Requested method is not implemented"
        }
    }
}
