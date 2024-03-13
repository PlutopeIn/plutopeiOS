//
//  WalletConnectPopupViewController+Delegate.swift
//  Plutope
//
//  Created by Trupti Mistry on 17/01/24.
//

import Foundation
import UIKit
import WalletConnectSign

// MARK: UITableViewDelegate Methods
extension WalletConnectPopupViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select row \(indexPath)")
        var session = self.sessions[indexPath.row]
        self.onConnection(session: session)
        
       // let pendingRequests = Sign.instance.getPendingRequests(topic: session?.topic)
       // showSessionRequest(pendingRequests[indexPath.row])
//        let itemTopic = sessionItems[indexPath.row].topic
//        if let session = Sign.instance.getSessions().first(where: {$0.topic == itemTopic}) {
//            showSessionDetails(with: session)
//        }
    }
}
