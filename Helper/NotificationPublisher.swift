//
//  NotificationPublisher.swift
//  Thesis1
//
//  Created by Zain Sohail on 08.03.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import Foundation

import UserNotifications

class NotificationPublisher: NSObject{
    func sendNotification(title: String?, body:String?){
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title!
        notificationContent.body = body!
        
        let date = Date().addingTimeInterval(1)
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        UNUserNotificationCenter.current().delegate = self
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "VerificationNotification", content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request){ error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func removeNotification(){
        NotificationCenter.default.removeObserver(self)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "VerificationNotification"), object: nil)
    }
}

extension NotificationPublisher: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification is about to be presented")
        completionHandler([.sound,.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let identifier = response.actionIdentifier
        
        switch identifier {
            
        case UNNotificationDismissActionIdentifier:
            print("The notification was dismissed")
            completionHandler()
            
        case UNNotificationDefaultActionIdentifier:
            print("the user opened the app from the notification")
            completionHandler()
            
        default:
            print("the default case was called")
            completionHandler()
        }
    }
}
