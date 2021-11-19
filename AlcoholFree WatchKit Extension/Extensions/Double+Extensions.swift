//
//  Int+Extensions.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 박신홍 on 2021/11/19.
//

import Foundation


extension Double {
    func toStringInGlasses() -> String {
        return "\(Int(self).description)잔"
    }
    
    func toStringInBottle(drink: Drink) -> String {
        return "\(drink.category) \(String(format: "%.2f", self.convertToBottle(drink: drink)))병"
    }
    
    func convertToMilliliters(drink: Drink) -> Double {  // 잔 -> ml
        return self * Double(drink.volumePerGlass)
    }
    
    func convertToGlasses(drink: Drink) -> Double {  // ml -> 잔
        return self / Double(drink.volumePerGlass)
    }
    
    func convertToBottle(drink: Drink) -> Double {  // 잔 -> 병
        return self.convertToMilliliters(drink: drink) / drink.volumeMl
    }
}
