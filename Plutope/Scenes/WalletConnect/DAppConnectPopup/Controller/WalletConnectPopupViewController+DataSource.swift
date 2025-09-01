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
      //  DispatchQueue.main.async { [weak self] in
//        if let unwrappedIconURL = URL(string: data.peer.icons.first ?? "") {
//            DispatchQueue.main.async {
//                if let imageData = try? Data(contentsOf: unwrappedIconURL) {
//                    cell.ivWallet.image = UIImage(data: imageData)
//                }
//            }
//           
//        } else {
//        }
        if let unwrappedIconURL = data.peer.icons.first {
            loadFavicon(for: unwrappedIconURL) { image in
                cell.ivWallet.image = image // Set image after loading
            }
        } else {
            cell.ivWallet.image = UIImage(named: "placeholder") // Set a default image if URL is nil
        }
        
        return cell
    }
    func loadFavicon(for urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil) // Return nil if URL is invalid
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error loading image:", error.localizedDescription)
                completion(nil)
                return
            }

            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
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
