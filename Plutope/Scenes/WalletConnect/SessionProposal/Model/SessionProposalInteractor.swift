import Foundation

import ReownWalletKit
import ReownRouter

final class SessionProposalInteractor {
    func approve(proposal: Session.Proposal, EOAAccount: Account) async throws -> Bool {
        // Following properties are used to support all the required and optional namespaces for the testing purposes
        // let supportedMethods = Set(proposal.requiredNamespaces.flatMap { $0.value.methods } + (proposal.optionalNamespaces?.flatMap { $0.value.methods } ?? []))
        
//        account.address = "sdfsd";
//        let newAecount =
         let supportedEvents = Set(proposal.requiredNamespaces.flatMap { $0.value.events } + (proposal.optionalNamespaces?.flatMap { $0.value.events } ?? []))
        
        let supportedRequiredChains = proposal.requiredNamespaces["eip155"]?.chains
        let supportedOptionalChains = proposal.optionalNamespaces?["eip155"]?.chains ?? []
        let supportedChains = Set(supportedRequiredChains ?? []).union(Set(supportedOptionalChains))
//        let supportedAccounts = Array(supportedChains).map { Account(blockchain: $0, address: account.address)! }
        let supportedMethods = [ "eth_sendTransaction",
                                 "personal_sign",
                                 "eth_accounts",
                                 "eth_requestAccounts",
                                 "eth_call",
                                 "eth_getBalance",
                                 "eth_sendRawTransaction",
                                 "eth_sign",
                                 "eth_signTransaction",
                                 "eth_signTypedData",
                                 "eth_signTypedData_v3",
                                 "eth_signTypedData_v4"]
       // let supportedEvents = ["accountsChanged", "chainChanged"]
       // let supportedChains  = (supportedRequiredChains ?? []).union(supportedOptionalChains)
        
        print("supportedMethods",WalletData.shared.myWallet?.address)
        
        guard let currentSelectedWallet = WalletData.shared.myWallet?.address as? String else { return ((EOAAccount.address as? String) != nil) }

        let supportedAccounts = [Account(blockchain: Blockchain("eip155:1")!, address: currentSelectedWallet)!, Account(blockchain: Blockchain("eip155:137")!, address: currentSelectedWallet)!,Account(blockchain: Blockchain("eip155:56")!, address: currentSelectedWallet)!,Account(blockchain: Blockchain("eip155:66")!, address: currentSelectedWallet)!,Account(blockchain: Blockchain("eip155:10")!, address: currentSelectedWallet)!,Account(blockchain: Blockchain("eip155:97")!, address: currentSelectedWallet)!,Account(blockchain: Blockchain("eip155:42161")!, address: currentSelectedWallet)!,Account(blockchain: Blockchain("eip155:43114")!, address: currentSelectedWallet)!,Account(blockchain: Blockchain("eip155:8453")!, address: currentSelectedWallet)!]
        /* Use only supported values for production. I.e:
        let supportedMethods = ["eth_signTransaction", "personal_sign", "eth_signTypedData", "eth_sendTransaction", "eth_sign"]
        let supportedEvents = ["accountsChanged", "chainChanged"]
        let supportedChains = [Blockchain("eip155:1")!, Blockchain("eip155:137")!]
        let supportedAccounts = [Account(blockchain: Blockchain("eip155:1")!, address: ETHSigner.address)!, Account(blockchain: Blockchain("eip155:137")!, address: ETHSigner.address)!]
        */
        let sessionNamespaces = try AutoNamespaces.build(
            sessionProposal: proposal,
            chains: Array(supportedChains),
            methods: Array(supportedMethods),
            events: Array(supportedEvents),
            accounts: supportedAccounts
        )
        try await WalletKit.instance.approve(proposalId: proposal.id, namespaces: sessionNamespaces, sessionProperties: proposal.sessionProperties)

        if let uri = proposal.proposer.redirect?.native {
            ReownRouter.goBack(uri: uri)
            return false
        } else {
            
            return true
        }
    }

    func reject(proposal: Session.Proposal) async throws {
        try await WalletKit.instance.rejectSession(proposalId: proposal.id, reason: .userRejected)
        
        /* Redirect */ //
        
        if let uri = proposal.proposer.redirect?.native {
            ReownRouter.goBack(uri: uri)
        }
    }
    private func getSessionProperties(addresses: [String]) -> [String: String] {
        var addressCapabilities: [String] = []

        // Iterate over the addresses and construct JSON strings for each address
        for address in addresses {
            let capability = """
            "\(address)":{
                "0xaa36a7":{
                    "atomicBatch":{
                        "supported":true
                    }
                }
            }
            """
            addressCapabilities.append(capability)
        }

        // Join all the address capabilities into one JSON-like structure
        let sepoliaAtomicBatchCapabilities = "{\(addressCapabilities.joined(separator: ","))}"

        let sessionProperties: [String: String] = [
            "bundler_name": "pimlico",
            "capabilities": sepoliaAtomicBatchCapabilities
        ]

        print(sessionProperties)
        return sessionProperties
    }
}
