//
//  PaceViewModel.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 박신홍 on 2021/11/19.
//

import Foundation

// MARK: - Properties
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
    
    var warningMessage: String? {
        // TODO wavePercentage에 따라 다른 경고 메시지 내보낼 것
        return "너무 많이 마시고 있어요!"
    }
}

// MARK: - Classifiers
extension GlobalDrinkViewModel: MotionClassifierDelegate, SoundClassifierDelegate {
    func startDrinkClassification() {
        motionClassifier.delegator = self
        HealthKitSessionManager.shared.startBackgroundSession()
        motionClassifier.startMotionUpdates()
        DispatchQueue.global(qos: .background).async {
            SoundClassifier.shared.start(resultsObserver: ResultsObserver(delegate: self))
        }
    }
    
    func stopDrinkClassification() {
        motionClassifier.stopMotionUpdates()
        SoundClassifier.shared.stop()
        HealthKitSessionManager.shared.endBackgroundSession()
    }
    
    func drinkMotionDetected() {
        // TODO
        currentNumberOfGlasses += 1
        print("[GlobalDrinkViewModel] Drink Motion Detected")
    }
    
    func drinkSoundDetected(confidence: Double) {
        // TODO
        currentNumberOfGlasses += 1
        print("[GlobalDrinkViewModel] Drink Sound Detected")
    }
}

// MARK: - Other Logics
extension GlobalDrinkViewModel {
    // 기타 비즈니스 로직은 여기에
}
