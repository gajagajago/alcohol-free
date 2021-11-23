import WatchKit
import UserNotifications

class ExtensionDelegate: NSObject, WKExtensionDelegate, UNUserNotificationCenterDelegate {
    
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
            switch response.actionIdentifier {
            case "full":
                print("풀샷이 선택되었습니다.")
                break;
            case "half":
                print("반샷이 선택되었습니다.")
                break;
            case "sip":
                print("홀짝이 선택되었습니다.")
                break;
            case "no":
                print("안마심이 선택되었습니다.")
                break;
            default:
                break;
            }
        }
        
        completionHandler()
    }
}
