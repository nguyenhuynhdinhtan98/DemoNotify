//
//  UNService.swift
//  DemoNotify
//
//  Created by Tân Nguyễn on 31/03/2023.
//

import Foundation
import UserNotifications

class UNService: NSObject {
    private override init() {}
    static let shared: UNService = UNService()
    
    let unCenter = UNUserNotificationCenter.current()
    
    func authorize() {
        let options: UNAuthorizationOptions = [.alert,.badge,.sound,.carPlay]
        unCenter.requestAuthorization(options: options) { (granted,error) in
            print(error)
            guard granted else {
                print("USER GRANTED")
                return
            }
            self.configure()
        }
    }
    
    func configure() {
        unCenter.delegate = self
    }
}

extension UNService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("UN did recive response")
    }
}
