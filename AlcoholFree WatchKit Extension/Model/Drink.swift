//
//  Drink.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 유준열 on 2021/11/06.
//

import Foundation
import SwiftUI

struct Drink: Hashable, Codable {
    var id: Int
    var name: String
//    var aliases: Array<String>
    var category: String
    var alcoholPercent: Double
    var volumeMl: Int
}
