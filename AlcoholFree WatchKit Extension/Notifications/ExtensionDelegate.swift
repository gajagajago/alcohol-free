import WatchKit
import UserNotifications

class ExtensionDelegate: NSObject, WKExtensionDelegate, UNUserNotificationCenterDelegate {
    var delegate: DrinkDetectedDelegate?
    
    func registerDelgate(delegate: DrinkDetectedDelegate) {
        self.delegate = delegate
    }
    
    func applicationDidFinishLaunching() {
        setUNUserNotificationDelegate()
    }
    
    func setUNUserNotificationDelegate() {
        UNUserNotificationCenter.current().delegate = self
    }
    
    // Method triggered for all notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("푸시를 보여줬습니다.")
        completionHandler([.list, .banner,.sound])
    }
    
    // Method triggered for async action notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if (response.notification.request.content.categoryIdentifier == "DrinkDetect") {
            DrinkDetectedDelegateManager.shared?.drinkDetected(identifier: response.actionIdentifier)
        }
        
        completionHandler()
    }
}

class DrinkDetectedDelegateManager {
    static var shared: DrinkDetectedDelegate?
}

protocol DrinkDetectedDelegate {
    func drinkDetected(identifier: String)
}
