//
//  NotificationService.swift
//  NotificationExtension
//
//  Created by Jokin Egia on 25/10/21.
//

import UserNotifications
import FirebaseMessaging

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent { //Extract URL with method
            // Modify the notification content here...
            FIRMessagingExtensionHelper().populateNotificationContent(
                bestAttemptContent,
                withContentHandler: contentHandler)
            let data = bestAttemptContent.userInfo as NSDictionary
            let pref = UserDefaults.init(suiteName: "group.id.gits.notifserviceextension")
            pref?.set(data, forKey: "NOTIF_DATA")
            pref?.synchronize()
            
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
}
