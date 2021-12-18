//
//  NotificationDelegate.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 19/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import UIKit
import UserNotifications
import FirebaseMessaging

final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
    
    // Request for push notification
    func registerForPushNotifications(application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) {[weak self]  granted, _ in
            
            guard let self = self, granted else { return }
            
            center.delegate = self
            
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }
    
    // Display push notification when app in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if #available(iOS 14, *) {
            completionHandler([.badge, .sound, .banner])
        } else {
            completionHandler([.badge, .sound, .alert])
        }
    }
    
    // Handle tap on push notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        defer { completionHandler() }
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
    }
}

// MARK: PUSH NOTIFICATION
// iOS will call this method once the device has sucessfully registered for push notifications
// As the simulator is not able to receive notifications remotely the delegate method is never called
extension AppDelegate {
    
    func application(
        _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            
            Messaging.messaging().apnsToken = deviceToken
            let token = deviceToken.reduce("") { $0 +
                String(format: "%02x", $1) }
            print("TOKEN:", token)
    }
    
    // iOS will call this method when it fails to register the device for pushes
    func application(
        _ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) { print("ERROR:", error)
    }
}

// MARK: Firbase Push Notification
extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        Messaging.messaging().subscribe(toTopic: "general") { error in
            print("Subscribed to general topic")
        }
        
#if DEBUG
        Messaging.messaging().subscribe(toTopic: "general_dev") { error in
            print("Subscribed to general_dev topic")
        }
#endif
    }
}
