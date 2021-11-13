import Foundation
import UserNotifications
import UIKit

struct Notification {
    var id: String
    var title: String
}

class LocalNotificationManager {
    var notifications = [Notification]()
    
    func requestPermission() -> Void {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings{ (settings) in
            if (settings.authorizationStatus == .authorized) {
                print("푸시 알림이 허용되었습니다.")
            } else {
                print("푸시 알림이 거부되었습니다.")
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                }
            }
        }
    }
    
    func addNotification(title: String) -> Void {
        notifications.append(Notification(id: UUID().uuidString, title: title))
    }
    
    func schedule() -> Void {
          UNUserNotificationCenter.current().getNotificationSettings { settings in
              switch settings.authorizationStatus {
              case .notDetermined:
                  self.requestPermission()
              case .authorized, .provisional:
                  self.scheduleNotifications()
              default:
                  break
            }
        }
        
    }
    
    func scheduleNotifications() -> Void {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.categoryIdentifier = "myCategory"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id: \(notification.id)")
            }
        }
    }
    
    func initNotiCategory() {
        UNUserNotificationCenter.current().setNotificationCategories([mkDrinkDetectNotiCategory()])
        print("푸시 알림 카테고리를 생성했습니다.")
    }
    
    func mkDrinkDetectNotiCategory() -> UNNotificationCategory {
        let category = UNNotificationCategory(identifier: "감지", actions: mkDrinkDetectNotiActions(), intentIdentifiers: [], options: [])
        
        return category
    }
    
    func mkDrinkDetectNotiActions() -> [UNNotificationAction] {
        let fullshot = UNNotificationAction(identifier: "full", title: "풀샷", options: [])
        let halfshot = UNNotificationAction(identifier: "half", title: "반샷", options: [])
        let sipshot = UNNotificationAction(identifier: "sip", title: "홀짝", options: [])
        let noshot = UNNotificationAction(identifier: "no", title: "안마심", options: [])
        
        return [fullshot, halfshot, sipshot, noshot]
    }
}
