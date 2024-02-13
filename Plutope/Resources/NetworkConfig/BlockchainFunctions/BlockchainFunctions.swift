//
//  BlockchainFunctions.swift
//  PlutoPe
//
//  Created by Admin on 02/06/23.
//
import Foundation
import Web3
protocol BlockchainFunctions {
    func sendTokenOrCoin(_ receiverAddress: String?, tokenAmount: Double, completion: @escaping ((Bool,String?,EthereumData?) -> Void))
    func getBalance(completion: @escaping ((String?) -> Void))
    func swapTokenOrCoin(_ receiverAddress: String?, gas: String,gasPrice: String,rawData: String,tokenAmount: String,completion: @escaping ((Bool,String?,EthereumData?) -> Void))
    func approveTransactionForSwap(_ gasLimit: String?,_ gasPrice: String?, _ routerAddress: String?, tokenAmount: Double, completion: @escaping ((Bool, String?, EthereumData?) -> Void))
    func getGasFee(_ receiverAddress: String?, tokenAmount: Double, completion: @escaping ((Bool, String?,String?,String?,String?,EthereumData?) -> Void))
    func getGasPrice( completion: @escaping ((Bool, String?,String?,String?, EthereumData?) -> Void))
    func getDecimal(completion: @escaping ((String?) -> Void))
    func signAndSendTranscation(_ receiverAddress: String?, gasLimit: BigUInt,gasPrice: BigUInt,txValue: BigUInt,rawData: String,completion: @escaping ((Bool,String?,EthereumData?) -> Void))
    func sendTokenOrCoinWithLavrageFee(_ receiverAddress: String?, tokenAmount: Double,nonce:String,gasAmount:String,gasLimit:String,completion: @escaping ((Bool,String?,EthereumData?) -> Void))
 } 
