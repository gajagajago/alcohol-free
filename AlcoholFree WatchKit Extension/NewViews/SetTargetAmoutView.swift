//
//  SetTargetAmoutView.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 박신홍 on 2021/11/19.
//

import SwiftUI

struct SetTargetAmoutView: View {
    let selectedDrinkType: Drink
    @State var targetNumberOfGlasses: Double  // digitalCrownRotation 때문에 어쩔 수 없이 Double로 선언
    var body: some View {
        VStack {
            Text("오늘의 목표는 몇 잔인가요?")
                .multilineTextAlignment(.center)
                .font(NanumFont.title)
                .lineSpacing(2)
            
            Spacer()
            
            Text(targetNumberOfGlasses.toStringInGlasses())
                .font(Font.custom(NanumFontNames.extraBold.rawValue, size: 28))
                .foregroundColor(.init(red: 0, green: 0.8, blue: 1))
            
            Text(targetNumberOfGlasses.toStringInBottle(drink: selectedDrinkType))
                .font(Font.custom(NanumFontNames.bold.rawValue, size: 14))
                .foregroundColor(.gray)
                .padding(.top, 0.1)
            
            Spacer()
            
            NavigationLink(destination: SetTargetAmoutView(selectedDrinkType: selectedDrinkType, targetNumberOfGlasses: targetNumberOfGlasses)) {
                Text("시작")
                    .font(NanumFont.buttonLabel)
            }
            .padding(.horizontal, 20)
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .focusable()
        .digitalCrownRotation($targetNumberOfGlasses, from: 1.0, through: 50.0, by: 1, sensitivity: .low)
    }
}

struct SetTargetAmoutView_Previews: PreviewProvider {
    static var previews: some View {
        SetTargetAmoutView(selectedDrinkType: drinks[0], targetNumberOfGlasses: 1)
    }
}
