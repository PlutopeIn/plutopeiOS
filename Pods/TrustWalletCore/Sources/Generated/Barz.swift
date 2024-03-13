// Copyright © 2017-2023 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.
//
// This is a GENERATED FILE, changes made here WILL BE LOST.
//

import Foundation

/// Barz functions
public struct Barz {

    /// Calculate a counterfactual address for the smart contract wallet
    ///
    /// - Parameter input: The serialized data of ContractAddressInput.
    /// - Returns: The address.
    public static func getCounterfactualAddress(input: Data) -> String {
        let inputData = TWDataCreateWithNSData(input)
        defer {
            TWDataDelete(inputData)
        }
        return TWStringNSString(TWBarzGetCounterfactualAddress(inputData))
    }

    /// Returns the init code parameter of ERC-4337 User Operation
    ///
    /// - Parameter factory: Wallet factory address (BarzFactory)
    /// - Parameter publicKey: Public key for the verification facet
    /// - Parameter verificationFacet: Verification facet address
    /// - Returns: The address.
    public static func getInitCodeFromPublicKey(factory: String, publicKey: String, verificationFacet: String) -> Data {
        let factoryString = TWStringCreateWithNSString(factory)
        defer {
            TWStringDelete(factoryString)
        }
        let publicKeyString = TWStringCreateWithNSString(publicKey)
        defer {
            TWStringDelete(publicKeyString)
        }
        let verificationFacetString = TWStringCreateWithNSString(verificationFacet)
        defer {
            TWStringDelete(verificationFacetString)
        }
        return TWDataNSData(TWBarzGetInitCodeFromPublicKey(factoryString, publicKeyString, verificationFacetString))
    }

    /// Returns the init code parameter of ERC-4337 User Operation
    ///
    /// - Parameter factory: Wallet factory address (BarzFactory)
    /// - Parameter attestationObject: Attestation object from created webauthn credentials
    /// - Parameter verificationFacet: Verification facet address
    /// - Returns: The address.
    public static func getInitCodeFromAttestationObject(factory: String, attestationObject: String, verificationFacet: String) -> Data {
        let factoryString = TWStringCreateWithNSString(factory)
        defer {
            TWStringDelete(factoryString)
        }
        let attestationObjectString = TWStringCreateWithNSString(attestationObject)
        defer {
            TWStringDelete(attestationObjectString)
        }
        let verificationFacetString = TWStringCreateWithNSString(verificationFacet)
        defer {
            TWStringDelete(verificationFacetString)
        }
        return TWDataNSData(TWBarzGetInitCodeFromAttestationObject(factoryString, attestationObjectString, verificationFacetString))
    }

    /// Converts the original ASN-encoded signature from webauthn to the format accepted by Barz
    ///
    /// - Parameter signature: Original signature
    /// - Parameter authenticatorData: Hex encoded authenticator data
    /// - Parameter origin: URL of the origin from clientDataJSON
    /// - Returns: Bytes of the formatted signature
    public static func getFormattedSignature(signature: Data, authenticatorData: Data, origin: String) -> Data {
        let signatureData = TWDataCreateWithNSData(signature)
        defer {
            TWDataDelete(signatureData)
        }
        let authenticatorDataData = TWDataCreateWithNSData(authenticatorData)
        defer {
            TWDataDelete(authenticatorDataData)
        }
        let originString = TWStringCreateWithNSString(origin)
        defer {
            TWStringDelete(originString)
        }
        return TWDataNSData(TWBarzGetFormattedSignature(signatureData, authenticatorDataData, originString))
    }


    init() {
    }


}
