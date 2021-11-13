import Foundation
import UserNotifications
import UIKit

struct Notification {
    var id: String
    var title: String
}

class LocalNotificationManager {
    var notifications = [Notification]()
    
    let center = UNUserNotificationCenter.current()
    let drinkDetectNotiIdentifier = "DrinkDetect"

    func requestPermission() -> Void {
        center.getNotificationSettings{ (settings) in
            if (settings.authorizationStatus == .authorized) {
                print("푸시 알림이 허용되었습니다.")
            } else {
                print("푸시 알림이 거부되었습니다.")
                self.center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                }
            }
        }
    }
    
    func addNotification(title: String) -> Void {
        notifications.append(Notification(id: UUID().uuidString, title: title))
    }
    
    func addDrinkDetectNoti() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "술 마심이 감지되었습니다. 마신 양을 체크해주세요."
        notificationContent.categoryIdentifier = drinkDetectNotiIdentifier
        
        // 감지 후 노티 주기까지 인터벌 설정 가능
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.0, repeats: false)
        
        let request = UNNotificationRequest(identifier: drinkDetectNotiIdentifier, content: notificationContent, trigger: notificationTrigger)
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            } else {
                print("마신 양 체크 노티가 발송되었습니다.")
            }
        })
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
        center.setNotificationCategories([mkDrinkDetectNotiCategory()])
        print("푸시 알림 카테고리를 생성했습니다.")
    }
    
    func mkDrinkDetectNotiCategory() -> UNNotificationCategory {
        let category = UNNotificationCategory(identifier: drinkDetectNotiIdentifier, actions: mkDrinkDetectNotiActions(), intentIdentifiers: [], options: [])
        
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
