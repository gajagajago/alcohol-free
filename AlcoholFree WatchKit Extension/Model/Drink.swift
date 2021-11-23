//
//  Drink.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 유준열 on 2021/11/06.
//

import Foundation
import SwiftUI

struct Drink: Hashable, Codable {
    let id: Int
    let name: String
    let category: String
    let alcoholPercent: Double
    let volumeMl: Double
    
    var volumePerGlass: Int {
        switch category {
        case "소주":
            return 50
        case "소맥":
            return 200
        case "맥주":
            return 200
        default:
            return 100
        }
    }
}
