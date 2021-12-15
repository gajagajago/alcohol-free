import Foundation
import UserNotifications
import UIKit

struct Notification {
    var id: String
    var title: String
}

class LocalNotificationManager {
    static let shared = LocalNotificationManager()
    
    let center = UNUserNotificationCenter.current()
    let drinkNormalNotiIdentifier = "Normal"
    let drinkDetectNotiIdentifier = "DrinkDetect"
    
    func initNotification() {
        requestPermission()
        initNotiCategory()
    }
    
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
    
    func addNormalNoti(title: String) -> Void {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.categoryIdentifier = drinkNormalNotiIdentifier
        notificationContent.sound = UNNotificationSound.default
        
        // 감지 후 노티 주기까지 인터벌 설정 가능
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: notificationTrigger)
                
        center.add(request, withCompletionHandler: { (error) in
            if let err = error {
                print(err.localizedDescription)
            }
        })
        print("알림 등록 완료")
    }
    
    func addDrinkDetectNotiFirst(activity: String) {
        if activity == "left" {
            addDrinkDetectNotiInternal(msg: "마신 양을 기록해주세요. 정확한 음주량 기록을 위해 앞으로는 계속 왼손으로 마셔주세요!")
        } else {
            addDrinkDetectNotiInternal(msg: "마신 양을 기록해주세요. 정확한 음주량 기록을 위해 앞으로는 계속 오른손으로 마셔주세요!")
        }
    }
    
    func addDrinkDetectNoti() {
        addDrinkDetectNotiInternal(msg: "음주가 감지되었습니다. 마신 양을 기록해주세요.")
    }
    
    private func addDrinkDetectNotiInternal(msg: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = msg
        notificationContent.categoryIdentifier = drinkDetectNotiIdentifier
        notificationContent.sound = UNNotificationSound.default
        
        // 감지 후 노티 주기까지 인터벌 설정 가능
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: notificationTrigger)
                
        center.add(request, withCompletionHandler: { (error) in
            if let err = error {
                print(err.localizedDescription)
            }
        })
        print("알림 등록 완료")
    }
    
    func initNotiCategory() {
        center.setNotificationCategories(mkNotiCategory())
        print("푸시 알림 카테고리를 생성했습니다.")
    }
    
    func mkNotiCategory() -> Set<UNNotificationCategory> {
        var categories = Set<UNNotificationCategory>();
        
        let categoryNormal = UNNotificationCategory(identifier: drinkNormalNotiIdentifier, actions: [], intentIdentifiers: [], options: [])
        
        let categoryDrinkDetect = UNNotificationCategory(identifier: drinkDetectNotiIdentifier, actions: mkDrinkDetectNotiActions(), intentIdentifiers: [], options: [])
        
        categories = [categoryNormal, categoryDrinkDetect]
        
        return categories
    }
    
    func mkDrinkDetectNotiActions() -> [UNNotificationAction] {
        let fullshot = UNNotificationAction(identifier: "full", title: "원샷", options: [])
        let halfshot = UNNotificationAction(identifier: "half", title: "반샷", options: [])
        let sipshot = UNNotificationAction(identifier: "sip", title: "홀짝", options: [])
        let noshot = UNNotificationAction(identifier: "no", title: "안마심", options: [])
        
        return [fullshot, halfshot, sipshot, noshot]
    }
}
