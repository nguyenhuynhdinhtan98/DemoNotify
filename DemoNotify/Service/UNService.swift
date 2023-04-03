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
            guard granted else {
                print("USER GRANTED")
                return
            }
            self.configure()
        }
    }
    
    func configure() {
        unCenter.delegate = self
        setupActionAndCategories()
    }
    
    func timerRequest(with interval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Timmer Finished"
        content.body = "Content timer request"
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = NotifyCategoriesID.timer.rawValue
        if let attachment = getAttachment(for: .timer) {
            content.attachments = [attachment]
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: "userNotification.timer", content: content, trigger: trigger)
        unCenter.add(request)
    }
    
    func dateRequest(with components: DateComponents) {
        let content = UNMutableNotificationContent()
        content.title = "Date Finished"
        content.body = "Content date request"
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = NotifyCategoriesID.date.rawValue
     
        if let attachment = getAttachment(for: .date) {
            content.attachments = [attachment]
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "userNotification.date", content: content, trigger: trigger)
        unCenter.add(request)
    }
    
    func locationRequest() {
        let content = UNMutableNotificationContent()
        content.title = "Location changed"
        content.body = "Content location request"
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = NotifyCategoriesID.location.rawValue
     
        if let attachment = getAttachment(for: .location) {
            content.attachments = [attachment]
        }
        
        let request = UNNotificationRequest(identifier: "userNotification.location", content: content, trigger: nil)
        unCenter.add(request)
    }
    
    func setupActionAndCategories () {
        let timerAction = UNNotificationAction(identifier: NotifyActionID.timer.rawValue, title: "Run time action",options: [.authenticationRequired])
        let dateAction = UNNotificationAction(identifier: NotifyActionID.date.rawValue, title: "Run date action",options: [.destructive])
        let locationAction = UNNotificationAction(identifier: NotifyActionID.location.rawValue, title: "Run location action",options: [.foreground])
        
        let timerCategory = UNNotificationCategory(identifier: NotifyCategoriesID.timer.rawValue, actions: [timerAction], intentIdentifiers: [])
        let dateCategory = UNNotificationCategory(identifier: NotifyCategoriesID.date.rawValue, actions: [dateAction], intentIdentifiers: [])
        let locationCategory = UNNotificationCategory(identifier: NotifyCategoriesID.location.rawValue, actions: [locationAction], intentIdentifiers: [])
        
        unCenter.setNotificationCategories([timerCategory,dateCategory,locationCategory])
       
    }
    func getAttachment(for id: NotifyAttachmentID) -> UNNotificationAttachment? {
        var imageName: String
        switch id {
        case .timer: imageName = "TimeAlert"
        case .date: imageName = "DateAlert"
        case .location: imageName = "LocationAlert"
        }
        guard let url = Bundle.main.url(forResource: imageName, withExtension: "png") else { return nil  }
        do {
            let attachment = try  UNNotificationAttachment(identifier: id.rawValue, url: url)
            return attachment
        } catch {
            return nil
        }
    }
}

extension UNService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let action = NotifyActionID(rawValue: response.actionIdentifier) {
            NotificationCenter.default.post(name: NSNotification.Name("internalNotification.handleAction"), object: action)
        }
        completionHandler()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("UN will recive response")
        let options: UNNotificationPresentationOptions = [.alert,.badge,.sound]
        completionHandler(options)
    }
}
