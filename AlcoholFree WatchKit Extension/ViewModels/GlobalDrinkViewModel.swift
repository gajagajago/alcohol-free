//
//  PaceViewModel.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 박신홍 on 2021/11/19.
//

import Foundation

class GlobalDrinkViewModel: ObservableObject {
    // 전역 상태 관리 변수
    
    @Published var selectedDrinkType = drinks[0]
    @Published var targetNumberOfGlasses: Double = 10.0
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
        return "\(Int(currentNumberOfGlasses).description)잔"
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
}
