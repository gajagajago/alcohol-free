//
//  NanumFont.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 박신홍 on 2021/11/19.
//

import Foundation
import SwiftUI

enum NanumFontNames: String {
    case light = "NanumSquareRoundOTFL"
    case regular = "NanumSquareRoundOTFR"
    case bold = "NanumSquareRoundOTFB"
    case extraBold = "NanumSquareRoundOTFEB"
}

struct NanumFont {
    static let title = Font.custom(NanumFontNames.bold.rawValue, size: 15, relativeTo: .title3)
    static let buttonLabel = Font.custom(NanumFontNames.regular.rawValue, size: 13, relativeTo: .body)
    static let plainLabel = Font.custom(NanumFontNames.regular.rawValue, size: 15, relativeTo: .body)
    static let boldLabel = Font.custom(NanumFontNames.bold.rawValue, size: 15, relativeTo: .body)
    static let extraBoldLabel = Font.custom(NanumFontNames.extraBold.rawValue, size: 16, relativeTo: .body)
}
