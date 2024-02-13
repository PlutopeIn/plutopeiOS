//
//  NotificationViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 08/06/23.
//
import UIKit
class NotificationViewController: UIViewController, Reusable {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tbvNotification: UITableView!
    
    var arrNotification: [NotificationListData] = [
        NotificationListData(data: [
            NotificationData(title: StringConstants.notificationTitle, description: "From Lorem ipsum.", time: "9:35 AM"),
            NotificationData(title: StringConstants.notificationTitle, description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod.", time: "9:35 AM")
            
        ]),
        
        NotificationListData(data: [
            NotificationData(title: StringConstants.notificationTitle, description: "From Lorem ipsum.", time: "9:35 AM"),
            NotificationData(title: StringConstants.notificationTitle, description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod.", time: "9:35 AM")
            
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: StringConstants.notification)
        
        /// Table Register
        tableRegister()
    }
    /// Table Register
    func tableRegister() {
        tbvNotification.delegate = self
        tbvNotification.dataSource = self
        tbvNotification.register(NotificationViewCell.nib, forCellReuseIdentifier: NotificationViewCell.reuseIdentifier)
    }
    
}
