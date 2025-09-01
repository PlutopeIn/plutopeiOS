//
//  MyCardViewController+LiveApiCalls.swift
//  Plutope
//
//  Created by Trupti Mistry on 12/07/24.
//

import Foundation
extension MyCardViewController {
    func getCardNew() {
        DGProgressView.shared.showLoader(to: view)
        
        myCardViewModel.getCardAPINew { status,msg, data  in
            if status == 1 {
                DGProgressView.shared.hideLoader()
                self.arrCardList = data ?? []
                self.filterCards = self.arrCardList
                DispatchQueue.main.async {
                    self.tbvCard.reloadData()
                    self.tbvCard.restore()
                }
                
            } else {
                DGProgressView.shared.hideLoader()
            }
        }

    }
}
