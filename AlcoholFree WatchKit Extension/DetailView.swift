//
//  DetailView.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 유준열 on 2021/10/14.
//

import SwiftUI

struct DetailView: View {
    var drinkClassifierManager = DrinkClassifierManager()
    var body: some View {
        TabView {
            PaceView()
            EndView()
        }.onAppear {
            // 모니터링 시작 전 백그라운드 세션 활성화
            HealthKitSessionManager.shared.startBackgroundSession()
            drinkClassifierManager.startMotionUpdates()
        }.onDisappear {
            drinkClassifierManager.stopMotionUpdates()
            HealthKitSessionManager.shared.endBackgroundSession()
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
