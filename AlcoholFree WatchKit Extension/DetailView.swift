//
//  DetailView.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 유준열 on 2021/10/14.
//

import SwiftUI

var timerInterval = 10 // Minutes

struct DetailView: View, ResultsDelegator {
    var selectedPace: Int
    @State var count = 0
    @State var currentPace = 0.0
    
    @State var timerIntervalCnt = 0
    var drinkingMotionDetectedCnt = 1
    
    let timer = Timer.publish(every: 1*60*Double(timerInterval), on: .main, in: .common).autoconnect() // Last 10 should be set to timerInterval
    
    var body: some View {
        TabView {
            PaceView(selectedPace: selectedPace, currentPace: $currentPace, timerInterval: timerInterval)
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
    }
    
    func delegate(identifier: String, confidence: Double) {
        if (identifier == "glass_clink") {
            count += 1
        }
    }
    
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selectedPace: 0)
    }
}
