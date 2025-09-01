import Foundation
import WalletConnectIdentity
import Web3
import WalletConnectSigner
import WalletConnectSign

enum ImportAccount: Codable {
    
    case custom(privateKey: String)
    case web3Modal(account: Account, topic: String)
    
    static let web3ModalId = "web3Modal"

    init?(input: String) {
        switch input.lowercased() {
        default:
            switch true {
            case input.starts(with: ImportAccount.web3ModalId):
                let components = input.components(separatedBy: "-")
                guard components.count == 3, let account = Account(components[1]) else {
                    return nil
                }
                self = .web3Modal(account: account, topic: components[2])

            default:
                if let _ = try? EthereumPrivateKey(hexPrivateKey: "0x" + input, ctx: nil) {
                    self = .custom(privateKey: input)
                } else if let _ = try? EthereumPrivateKey(hexPrivateKey: input, ctx: nil) {
                    self = .custom(privateKey: input.replacingOccurrences(of: "0x", with: ""))
                } else {
                    return nil
                }
            }
        }
    }

    var storageId: String {
        switch self {
        case .custom(let privateKey):
            return privateKey
        case .web3Modal(let account, let topic):
            return "\(ImportAccount.web3ModalId)-\(account.absoluteString)-\(topic)"
        }
    }

    var account: Account {
        switch self {
        case .custom(let privateKey):
            let address = try! EthereumPrivateKey(hexPrivateKey: "0x" + privateKey, ctx: nil).address.hex(eip55: true)
            print(address)
            return Account("eip155:1:\(address)")!
        case .web3Modal(let account, _):
            return account
        }
    }

    var privateKey: String {
        switch self {
        case .custom(let privateKey):
            return privateKey
        case .web3Modal:
            fatalError("Private key not available")
        }
    }

    func onSign(message: String) -> CacaoSignature {
        let privateKey = Data(hex: privateKey)
        let signer = MessageSignerFactory(signerFactory: DefaultSignerFactory()).create()
        let signature = try! signer.sign(message: message, privateKey: privateKey, type: .eip191)
        return signature
    }

    static func new() -> ImportAccount {
        let key = try! EthereumPrivateKey()
        return ImportAccount.custom(privateKey: key.rawPrivateKey.toHexString())
    }
}
