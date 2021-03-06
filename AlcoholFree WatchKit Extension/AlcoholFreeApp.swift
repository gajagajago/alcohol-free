//
//  AlcoholFreeApp.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 유준열 on 2021/09/30.
//

import SwiftUI

@main
struct AlcoholFreeApp: App {
    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var delegate
    @SceneBuilder var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(GlobalDrinkViewModel())
                .onAppear {
                    LocalNotificationManager.shared.initNotification()
                    
                }
        }

        WKNotificationScene(controller: NotificationController.self, category: "alcoholFree")
    }
}
