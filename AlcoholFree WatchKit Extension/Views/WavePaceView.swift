//
//  WavePaceView.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 박신홍 on 2021/11/19.
//

import SwiftUI

struct WavePaceView: View {
    @EnvironmentObject var globalViewModel: GlobalDrinkViewModel
    
    var body: some View {
        WaveBackground(percent: globalViewModel.wavePercentage) {
            VStack {
                
                Spacer()
                
                Group {
                    HStack(alignment: .firstTextBaseline) {
                        Text(globalViewModel.currentNumberOfGlassesAsString)
                            .font(Font.custom(NanumFontNames.extraBold.rawValue, size: 30))
                        
                        Text("/")
                            .font(Font.custom(NanumFontNames.extraBold.rawValue, size: 20))
                            .opacity(0.8)
                        
                        Text(globalViewModel.targetNumberOfGlassesAsString)
                            .font(Font.custom(NanumFontNames.extraBold.rawValue, size: 15))
                            .opacity(0.8)
                    }
                    .padding(.bottom, 5)
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text("알코올 섭취량")
                            .font(Font.custom(NanumFontNames.bold.rawValue, size: 13))
                            .opacity(0.8)
                        
                        Text(globalViewModel.alcoholConsumptionAsString)
                            .font(Font.custom(NanumFontNames.extraBold.rawValue, size: 14))
                    }
                    .padding(.bottom, 1)
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text("마지막 짠")
                            .font(Font.custom(NanumFontNames.bold.rawValue, size: 13))
                            .opacity(0.8)
                        
                        Text("7분 전")
                            .font(Font.custom(NanumFontNames.extraBold.rawValue, size: 14))
                    }
                    
                }
                .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 0)
                
                Spacer()
                
                // 아래 버튼은 디버깅 & 데모용입니다.
                HStack {
                    DrinkButton(text: "모션", iconName: "hand.draw") {
                        globalViewModel.drinkMotionDetected()
                    }
                    DrinkButton(text: "소리", iconName: "waveform.and.mic") {
                        globalViewModel.drinkSoundDetected(confidence: 100)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 5)
            }
            .ignoresSafeArea(.container, edges: .bottom)
        }
    }
}

struct WavePaceView_Previews: PreviewProvider {
    static var previews: some View {
        WavePaceView()
    }
}
