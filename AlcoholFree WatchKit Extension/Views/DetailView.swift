//
//  DetailView.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 유준열 on 2021/10/14.
//

import SwiftUI

var timerInterval = 1 // timer check 하는 주기
var timerThreshold = 10 // 초기 기준 시간
var standardAlcConstant = 0.7964 // 표준 알코올 계수
var gender = 0.7 // 임시 성별 계수
var weight = 70.0 // 임시 몸무게 계수

struct DetailView: View, ResultsDelegator, IncreaseDrinkingMotionCnt {
    var selectedPace: Int
    var selectedDrink: Drink
    
    @State var count = 0
    @State var totalCount = 0
    @State var currentPace = 0.0
    @State var bloodAlcPercent = 0.00
    
    @State var timerIntervalCnt = 0
    @State var drinkingMotionDetectedCnt = 0
    
    @State var timerConnected = false
    
    var motionClassifier = MotionClassifier()
    
    let timer = Timer.publish(
        every: 60*Double(timerInterval),
        tolerance: 0.1,
        on: .main,
        in: .common) 
    
    var body: some View {
        TabView {
            PaceView(
                selectedPace: selectedPace,
                currentPace: $currentPace,
                timerThreshold: timerThreshold,
                bloodAlcPercent: $bloodAlcPercent)
                .onReceive(timer) { time in
                    print("Timer !! Update stats")
                    // Update current pace
                    setCurrentPace()
                    // Update blood alcohol percent
                    setBloodAlcPercent()
                    timerIntervalCnt = timerIntervalCnt+1
                }
            EndView()
        }
        .onAppear {
            motionClassifier.delegator = self
            HealthKitSessionManager.shared.startBackgroundSession()
            motionClassifier.startMotionUpdates()
            SoundClassifier.shared.start(resultsObserver: ResultsObserver(delegator: self))
        }
        .onDisappear {
            motionClassifier.stopMotionUpdates()
            HealthKitSessionManager.shared.endBackgroundSession()
        }
    }
    
    func incrementTotalCnt(count: Int) {
        totalCount = totalCount + count
    }
    
    func increaseDrinkingMotionDetectedCnt() {
        drinkingMotionDetectedCnt += 1
    }
    
    func setCurrentPace() {
        let currTotalTime = Double(timerInterval * (timerIntervalCnt+1))
        
        if (drinkingMotionDetectedCnt >= 1) {
            incrementTotalCnt(count: count)
            count = 0
            drinkingMotionDetectedCnt = 0
        }
        else if (drinkingMotionDetectedCnt == 0 && count >= 1) {
            count = 1
        } else {
            count = 0
        }
        
        // Update current pace
        currentPace = Double(totalCount) / currTotalTime
        
        // Notify user if pace is too fast
        if (currentPace > Double(selectedPace)) {
            setNotification()
        }
    }
    
    func setBloodAlcPercent() {
        let alc = selectedDrink.alcoholPercent / 100
        let ml = (selectedDrink.category == "소주") ? 50 : (selectedDrink.category == "맥주" ? 200 : 100)
        
        let alcMg = alc * Double(ml) * Double(totalCount) * standardAlcConstant
        let alcPercent = alcMg / (gender*weight*1000)
        
        print("Alc percent %f", alcPercent)
        bloodAlcPercent = alcPercent
    }
    
    func delegate(identifier: String, confidence: Double) {
        if (identifier == "glass_clink") {
            // Init timer at first clink
            if (!timerConnected) {
                timerConnected = true
                timer.connect()
            }
            count += 1
            print("짠!")
            
            // 임시로 여기에 마신 양 체크 노티 달아놓겠습니다.
            LocalNotificationManager().addDrinkDetectNoti()
            
        }
    }
    
    func setNotification(){
        LocalNotificationManager().addNormalNoti(title: "현재 페이스가 목표 페이스를 초과했어요!")
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selectedPace: 0, selectedDrink: drinks[0])
    }
}
