//
//  NFTListViewModel.swift
//  Plutope
//
//  Created by Priyanka Poojara on 28/06/23.
//

import Foundation

class NFTListViewModel {
    
    private var failblock: BindFail?
    private lazy var repo: NFTRepo? = NFTRepo()
    
    var nftData: Observable<[NFTList]> = .init([])
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
    
    func apiGetNFTList(_ detail: String?, completion: @escaping (([NFTList]?,Bool,String) -> Void)) {
        
        let dispatchGroup = DispatchGroup()
        var mergedNFTList: [NFTList] = []
        var errorMessage: String = ""
        
        dispatchGroup.enter()
        repo?.apiGetNFTListPolygon(detail: detail, completion: { nftList, status, message in
            if status {
                mergedNFTList += nftList ?? []
            } else {
                errorMessage = message
                self.failblock?(false, message)
            }
            dispatchGroup.leave()
        })
        
        /*
        dispatchGroup.enter()
        repo?.apiGetNFTListBsc(detail: detail, completion: { nftList, status, message in
            if status {
                mergedNFTList += nftList ?? []
            } else {
                errorMessage = message
                self.failblock?(false, message)
            }
            dispatchGroup.leave()
        })
        */
        
        dispatchGroup.enter()
        repo?.apiGetNFTListEth(detail: detail, completion: { nftList, status, message in
            if status {
                mergedNFTList += nftList ?? []
            } else {
                errorMessage = message
                self.failblock?(false, message)
            }
            dispatchGroup.leave()
        })
        
        dispatchGroup.notify(queue: .main) {
            if !mergedNFTList.isEmpty {
                completion(mergedNFTList, true, "")
            } else {
                completion(nil, false, errorMessage)
            }
        }
        
    }
    
}
