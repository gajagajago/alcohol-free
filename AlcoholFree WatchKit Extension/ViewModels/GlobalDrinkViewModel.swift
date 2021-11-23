//
//  PaceViewModel.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 박신홍 on 2021/11/19.
//

import Foundation
import WatchKit

// MARK: - Properties
class GlobalDrinkViewModel: ObservableObject {
    // 전역 상태 관리 변수
    var motionClassifier = MotionClassifier()
    
    @Published var selectedDrinkType = drinks[0]
    @Published var targetNumberOfGlasses: Double
    @Published var currentNumberOfGlasses: Double = 0.0
    @Published var showChildNavigationViews: Bool = false  // true이면 root view로 pop된다.
    
    init(targetNumberOfGlasses: Double = 10) {
        self.targetNumberOfGlasses = targetNumberOfGlasses
        
        DrinkDetectedDelegateManager.shared = self
    }
    
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
    
    var volumeOfGlass: Double {
        if selectedDrinkType.category == "소주" {
            return 50
        } else {
            return 200
        }
    }
    
    var alcoholConsumption: Double {
        return currentNumberOfGlasses * volumeOfGlass * selectedDrinkType.alcoholPercent / 100
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
extension GlobalDrinkViewModel: MotionClassifierDelegate, SoundClassifierDelegate, DrinkDetectedDelegate {
    func startDrinkClassification() {
        motionClassifier.delegator = self
        HealthKitSessionManager.shared.startBackgroundSession()
        motionClassifier.startMotionUpdates()
        SoundClassifier.shared.start(resultsObserver: ResultsObserver(delegate: self))
    }
    
    func stopDrinkClassification() {
        self.motionClassifier.stopMotionUpdates()
        SoundClassifier.shared.stop()
        HealthKitSessionManager.shared.endBackgroundSession()
    }
    
    func drinkMotionDetected() {
        print("[GlobalDrinkViewModel] Drink Motion Detected")  // you can delete this line
        LocalNotificationManager.shared.addDrinkDetectNoti()
    }
    
    func drinkSoundDetected(confidence: Double) {
        print("[GlobalDrinkViewModel] Drink Sound Detected")  // you can delete this line
        LocalNotificationManager.shared.addDrinkDetectNoti()
    }
    
    func drinkDetected(identifier: String) {
        switch identifier {
        case "full":
            print("풀샷이 선택되었습니다.")
            currentNumberOfGlasses += 1
            break;
        case "half":
            print("반샷이 선택되었습니다.")
            currentNumberOfGlasses += 0.5
            break;
        case "sip":
            print("홀짝이 선택되었습니다.")
            currentNumberOfGlasses += 0.2
            break;
        case "no":
            print("안마심이 선택되었습니다.")
            break;
        default:
            break;
        }
    }
}

// MARK: - Other Logics
extension GlobalDrinkViewModel {
    // 기타 비즈니스 로직은 여기에
    
    func resetToInitialState() {
        selectedDrinkType = drinks[0]
        targetNumberOfGlasses = 10
        currentNumberOfGlasses = 0
    }
}
