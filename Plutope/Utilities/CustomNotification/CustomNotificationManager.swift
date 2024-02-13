//
//  CustomNotificationManager.swift
//  Plutope
//
//  Created by Mitali Desai on 29/08/23.
//

import Foundation
import UserNotifications

class CustomNotificationManager: NSObject {
    static let shared = CustomNotificationManager()
    
    private override init() {
        super.init()
    }
    
    func sendCustomNotification(title: String, body: String, delay: TimeInterval = 0) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification request: \(error.localizedDescription)")
            } else {
                print("Notification request added successfully")
            }
        }
    }
}
