//
//  DetailView.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 유준열 on 2021/10/14.
//

import SwiftUI

var timerInterval = 1 // timer check 하는 주기
var timerThreshold = 10 // 초기 기준 시간
struct DetailView: View, ResultsDelegator {
    var selectedPace: Int
    @State var count = 0
    @State var currentPace = 0.0
    
    @State var timerIntervalCnt = 0
    @State var drinkingMotionDetectedCnt = 1
    
    let timer = Timer.publish(every: 1*60*Double(timerInterval), on: .main, in: .common) // Last 10 should be set to timerInterval
    var body: some View {
        TabView {
            PaceView(selectedPace: selectedPace, currentPace: $currentPace, timerThreshold: timerThreshold)
                .onReceive(timer) { time in
                    setCurrentPace()
                    timerIntervalCnt = timerIntervalCnt+1
                }
            EndView()
        }.onAppear {
            // 모니터링 시작 전 백그라운드 세션 활성화
            HealthKitSessionManager.shared.startBackgroundSession()
            MotionClassifier.shared.startMotionUpdates()
            SoundClassifier.shared.start(resultsObserver: ResultsObserver(delegator: self))
        }.onDisappear {
            SoundClassifier.shared.stop()
            MotionClassifier.shared.stopMotionUpdates()
            HealthKitSessionManager.shared.endBackgroundSession()
        }
    }
    
    func setCurrentPace() {
        let prevTotalTime = Double(timerInterval*timerIntervalCnt)
        let prevTotalCnt = currentPace * prevTotalTime
        let currTotalTime = Double(timerInterval * (timerIntervalCnt+1))
        var currTotalCnt: Double
        
        if (drinkingMotionDetectedCnt >= 1) {
            currTotalCnt = prevTotalCnt + Double(count)
            count = 0
        }
        else if (drinkingMotionDetectedCnt == 0 && count >= 1) {
            //
            currTotalCnt = prevTotalCnt
            count = 1
        } else {
            // drinkingMotion = 0 && count = 0
            currTotalCnt = prevTotalCnt
            count = 0
        }
        
        currentPace = currTotalCnt / currTotalTime
    }
    
    func increaseDrinkingMotionDetectedCnt() {
        drinkingMotionDetectedCnt += 1
    }
    
    func delegate(identifier: String, confidence: Double) {
        if (identifier == "glass_clink") {
            // Init timer at first clink
            if (currentPace == 0.0) {
                timer.connect()
            }
            count += 1
        }
    }
    
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selectedPace: 0)
    }
}
