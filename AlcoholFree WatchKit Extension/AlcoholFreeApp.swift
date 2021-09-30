//
//  AlcoholFreeApp.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 유준열 on 2021/09/30.
//

import SwiftUI

@main
struct AlcoholFreeApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
