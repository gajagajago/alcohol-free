//
//  WavePaceView.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 박신홍 on 2021/11/19.
//

import SwiftUI

struct WavePaceView: View {
    let targetNumberOfGlasses: Double
    let selectedDrinkType: Drink
    @Binding var currentDrinkAmount: Double
    
    var fillRatio: Double {
        return currentDrinkAmount / targetNumberOfGlasses.convertToMilliliters(drink: selectedDrinkType)
    }
    
    var body: some View {
        WaveBackground(percent: fillRatio) {
            VStack {
                Text("Hello")
//                targetLabel()
//                if viewModel.isGoalReached {
//                    resetButton()
//                } else {
//                    DrinkButton(text: viewModel.drinkText, action: viewModel.didTapDrink)
//                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct WavePaceView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(160.0) {
            WavePaceView(targetNumberOfGlasses: 10, selectedDrinkType: drinks[2], currentDrinkAmount: $0)
            
        }
    }
}
