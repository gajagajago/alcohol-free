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
    var drinkingMotionDetectedCnt = 1
    
    let timer = Timer.publish(every: 1*60*Double(timerInterval), on: .main, in: .common) // Last 10 should be set to timerInterval
    
    var body: some View {
        TabView {
            PaceView(selectedPace: selectedPace, currentPace: $currentPace, timerThreshold: timerThreshold)
                .onReceive(timer) { time in
                    setCurrentPace()
                    timerIntervalCnt = timerIntervalCnt+1
                }
            EndView()
        }
        .onAppear {
            SoundClassifier.shared.start(resultsObserver: ResultsObserver(delegator: self))
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
        
        if (currentPace > Double(selectedPace)) {
            setNotification()
        }
    }
    
    func delegate(identifier: String, confidence: Double) {
        if (identifier == "glass_clink") {
            // Init timer at first clink
            if (currentPace == 0.0) {
                timer.connect()
            }
            count += 1
            print("짠!")
        }
    }
    
    func setNotification(){
        let manager = LocalNotificationManager()
        manager.addNotification(title: "현재 페이스가 목표 페이스를 초과했어요!")
        manager.schedule()
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selectedPace: 0)
    }
}
