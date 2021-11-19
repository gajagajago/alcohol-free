//
//  PaceViewModel.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 박신홍 on 2021/11/19.
//

import Foundation

class GlobalDrinkViewModel: ObservableObject {
    // 전역 상태 관리 변수
    var motionClassifier = MotionClassifier()
    
    @Published var selectedDrinkType = drinks[0]
    @Published var targetNumberOfGlasses: Double = 20.0
    @Published var currentNumberOfGlasses: Double = 0.0
    
    var targetMilliliters: Double {
        // 목표 잔 -> 목표 m
        return targetNumberOfGlasses * Double(selectedDrinkType.volumePerGlass)
    }
    
    var targetNumberOfBottles: Double {
        // 목표 잔 -> 목표 병
        return (targetMilliliters / selectedDrinkType.volumeMl)
    }
    
    var targetNumberOfGlassesAsString: String {
        return "\(Int(targetNumberOfGlasses).description)잔"
    }
    
    var currentNumberOfGlassesAsString: String {
        return "\(String(format: "%.1f", currentNumberOfGlasses))잔"
    }
    
    var targetNumberOfBottlesAsString: String {
        return "\(selectedDrinkType.category) \(String(format: "%.2f", targetNumberOfBottles))병"
    }
    
    var needWarningForHighTarget: Bool {
        // 목표를 두 병 넘게 잡으면 경고 메시지
        return targetNumberOfBottles >= 2
    }
    
    var wavePercentage: Double {
        // 물결의 높이를 결정
        return currentNumberOfGlasses / targetNumberOfGlasses
    }
    
    var alcoholConsumption: Double {
        // TODO
        // 알코올 섭취량(g)
        return 4.8
    }
    
    var alcoholConsumptionAsString: String {
        return "\(String(format: "%.1f", alcoholConsumption))g"
    }
}

extension GlobalDrinkViewModel: MotionClassifierDelegate, ResultsDelegate {
    func startDrinkClassification() {
        motionClassifier.delegator = self
        HealthKitSessionManager.shared.startBackgroundSession()
        motionClassifier.startMotionUpdates()
        DispatchQueue.global(qos: .background).async {
            SoundClassifier.shared.start(resultsObserver: ResultsObserver(delegator: self))
        }
    }
    
    func stopDrinkClassification() {
        motionClassifier.stopMotionUpdates()
        SoundClassifier.shared.stop()
        HealthKitSessionManager.shared.endBackgroundSession()
    }
    
    func drinkMotionDetected() {
        // TODO
        currentNumberOfGlasses += 0.5
        print("[GlobalDrinkViewModel] Drink Motion Detected")
    }
    
    func drinkSoundDetected(confidence: Double) {
        // TODO
        currentNumberOfGlasses += 0.5
        print("[GlobalDrinkViewModel] Drink Sound Detected")
    }
}
