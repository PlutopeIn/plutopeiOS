//
//  WalletConnectPopupViewController+DataSource.swift
//  Plutope
//
//  Created by Trupti Mistry on 17/01/24.
//

import Foundation
import UIKit

// MARK: UITableViewDataSource Methods
extension WalletConnectPopupViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  sessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tbvSession.dequeueReusableCell(indexPath: indexPath) as WalletConnectPopupTbvCell
        let data = sessions[indexPath.row]
        cell.selectionStyle = .none
        cell.lblName.text = data.peer.name
        cell.lblUrl.text = data.peer.url
        cell.lblName.textAlignment = (LocalizationSystem.sharedInstance.getLanguage() == "ar") ? .right : .left
        cell.ivWallet.image = nil
        
        if let unwrappedIconURL = URL(string: data.peer.icons.first ?? "") {
            if let imageData = try? Data(contentsOf: unwrappedIconURL) {
                DispatchQueue.main.async { [weak self] in
                    cell.ivWallet.image = UIImage(data: imageData)
                }
            }
        } else {
        }
        return cell
    }
    // remove session from index path
    func removeSession(at indexSet: IndexSet) async {
        let localSessions = sessions // Capture sessions in a local variable
        
        if let index = indexSet.first, index < localSessions.count {
            try? await interactor.disconnectSession(session: localSessions[index])
            DispatchQueue.main.async {
                self.tbvSession.reloadData()
                self.tbvSession.restore()
            }
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Handle delete action
            let indexSet = IndexSet(integer: indexPath.row)
            Task(priority: .high) {
                await removeSession(at: indexSet)
            }
        }
    }
}
