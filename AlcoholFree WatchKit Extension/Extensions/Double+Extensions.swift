//
//  Int+Extensions.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 박신홍 on 2021/11/19.
//

import Foundation


extension Double {
    func asNumberOfGlasses() -> String {
        return "\(Int(self).description)잔"
    }
    
    func asNumberOfBottle(drink: Drink) -> String {
        return "\(drink.category) \(String(format: "%.2f", self * Double(drink.volumePerGlass) / drink.volumeMl))병"
    }
}
