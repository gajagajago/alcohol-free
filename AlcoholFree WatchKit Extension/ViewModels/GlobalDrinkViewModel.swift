//
//  PaceViewModel.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 박신홍 on 2021/11/19.
//

import Foundation
import WatchKit
import SwiftUICharts
import SwiftUI

// MARK: - Properties
class GlobalDrinkViewModel: ObservableObject {
    // 전역 상태 관리 변수
    var motionClassifier = MotionClassifier()
    var firstDrinkTimestamp: TimeInterval?
    var notiTimestamp: TimeInterval = NSDate().timeIntervalSince1970
    
    @Published var selectedDrinkType = drinks[0]
    @Published var targetNumberOfGlasses: Double
    @Published var currentNumberOfGlasses: Double = 0.0
    @Published var showChildNavigationViews: Bool = false  // true이면 root view로 pop된다.
    
    @Published var lastDrinkTimestamp: TimeInterval?
    @Published var datapoints: [DataPoint] = []  // 술 마시는 히스토리 기록
    
    var refreshingTimer: Timer?
    
    // Chart에 사용될 카테고리
    let sipLegend = Legend(color: .white, label: "홀짝", order: 3)
    let halfLegend = Legend(color: .white, label: "반샷", order: 2)
    let fullLegend = Legend(color: .orange, label: "원샷", order: 1)
    let placeholderLegend = Legend(color: .white.opacity(0.1), label: "NaN", order: 0)
    
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
    
    var alcoholConsumption: Double {
        return currentNumberOfGlasses * Double(selectedDrinkType.volumePerGlass) * selectedDrinkType.alcoholPercent / 100
    }
    
    var alcoholConsumptionAsString: String {
        return "\(String(format: "%.1f", alcoholConsumption))g"
    }
    
    var warningMessage: String? {
        if wavePercentage >= 1.0 {
            return "⛔️ 목표 주량을 초과했어요."
        } else if wavePercentage >= 0.8 {
            return "⚠️ 목표 주량에 근접해가고 있어요."
        }
        return nil
    }
    
    var lastDrinkMinutesPassed: Int? {
        // 마지막 짠 몇 분 전이었는지
        guard let lastDrinkTimestamp = lastDrinkTimestamp else {
            return nil
        }
        return Int((NSDate().timeIntervalSince1970 - lastDrinkTimestamp) / 60)
    }
    
    var drinkHistoryDataPoints: [DataPoint] {
        if datapoints.count > 25 {
            return datapoints.suffix(25)
        } else {
            var paddedDatapoints = datapoints
            for i in 1...(25 - datapoints.count) {
                paddedDatapoints.append(.init(value: 0.01, label: LocalizedStringKey(String(i)), legend: placeholderLegend))
            }
            return paddedDatapoints
        }
    }
    
    var averagePaceDataPoint: DataPoint? {
        let minute = 1
        let avg = averageDrinkAmount(per: minute)
        let color: Color = avg > 2 ? .red : (avg >= 1 ? .orange : .green)
        let maxValue = datapoints.max()?.endValue ?? 0
        if avg > maxValue {
            return DataPoint(value: maxValue, label: "\(String(format: "%.2f", avg))잔", legend: .init(color: color, label: "avgLegend"))
        }
        return DataPoint(value: avg, label: "\(String(format: "%.2f", avg))잔/분", legend: .init(color: color, label: "avgLegend"))
    }
}

// MARK: - Classifiers
extension GlobalDrinkViewModel: MotionClassifierDelegate, SoundClassifierDelegate, DrinkDetectedDelegate {
    
    func startDrinkClassification() {
        motionClassifier.delegator = self
        
        HealthKitSessionManager.shared.startBackgroundSession()
        motionClassifier.startMotionUpdates()
        SoundClassifier.shared.start(resultsObserver: ResultsObserver(delegate: self))
        
        firstDrinkTimestamp = NSDate().timeIntervalSince1970
        refreshingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }
    
    func stopDrinkClassification() {
        self.motionClassifier.stopMotionUpdates()
        SoundClassifier.shared.stop()
        HealthKitSessionManager.shared.endBackgroundSession()
    }
    
    func drinkMotionDetected() {
        print("[GlobalDrinkViewModel] Drink Motion Detected")  // you can delete this line
        if notiTimestamp + 5 < NSDate().timeIntervalSince1970 {
            LocalNotificationManager.shared.addDrinkDetectNoti()
        }
    }
    
    func drinkSoundDetected(confidence: Double) {
        print("[GlobalDrinkViewModel] Drink Sound Detected")  // you can delete this line
        notiTimestamp = NSDate().timeIntervalSince1970
        
        LocalNotificationManager.shared.addDrinkDetectNoti()
    }
    
    func drinkDetected(identifier: String) {
        
        if let _ = firstDrinkTimestamp { } else {
            firstDrinkTimestamp = NSDate().timeIntervalSince1970
        }
        
        var numberOfGlassesAdded: Double = 0
        switch identifier {
        case "full":
            print("원샷이 선택되었습니다.")
            numberOfGlassesAdded = 1
            break;
        case "half":
            print("반샷이 선택되었습니다.")
            numberOfGlassesAdded = 0.5
            break;
        case "sip":
            print("홀짝이 선택되었습니다.")
            numberOfGlassesAdded = 0.2
            break;
        case "no":
            print("안마심이 선택되었습니다.")
            break;
        default:
            break;
        }
        currentNumberOfGlasses += numberOfGlassesAdded
        if numberOfGlassesAdded != 0 {
            updateLastDrinkTimestamp()
            appendDrinkHistory(with: numberOfGlassesAdded)
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
        lastDrinkTimestamp = nil
        firstDrinkTimestamp = nil
        refreshingTimer?.invalidate()
        datapoints = []
    }
    
    func getLegend(of numberOfGlassesAdded: Double) -> Legend {
        switch numberOfGlassesAdded {
        case 1:
            return fullLegend
        case 0.5:
            return halfLegend
        case 0.2:
            return sipLegend
        default:
            return halfLegend
        }
    }
    
    @objc func timerCallback() {
        objectWillChange.send()
    }
    
    private func updateLastDrinkTimestamp() {
        lastDrinkTimestamp = NSDate().timeIntervalSince1970
    }
    
    private func appendDrinkHistory(with numberOfGlassesAdded: Double) {
        datapoints.append(.init(value: numberOfGlassesAdded, label: LocalizedStringKey(String(NSDate().timeIntervalSince1970)), legend: getLegend(of: numberOfGlassesAdded)))
    }
    
    private func averageDrinkAmount(per minute: Int) -> Double {
        guard let first = firstDrinkTimestamp  else { return 0 }
        let now = NSDate().timeIntervalSince1970
        let avgPerSec = currentNumberOfGlasses / (now - first)
        return avgPerSec * 60 * Double(minute)
    }
}
