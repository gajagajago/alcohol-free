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
                
                Spacer()
                
                Group {
                    HStack(alignment: .firstTextBaseline) {
                        Text("9잔")
                            .font(Font.custom(NanumFontNames.extraBold.rawValue, size: 30))
                        
                        Text("/")
                            .font(Font.custom(NanumFontNames.extraBold.rawValue, size: 20))
                            .opacity(0.8)
                        
                        Text("24잔")
                            .font(Font.custom(NanumFontNames.extraBold.rawValue, size: 15))
                            .opacity(0.8)
                    }
                    .padding(.bottom, 5)
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text("알코올 섭취량")
                            .font(Font.custom(NanumFontNames.bold.rawValue, size: 13))
                            .opacity(0.8)
                        
                        Text("4.8g")
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
                
                HStack {
                    Button(action: {
                        withAnimation {
                            // action
                        }
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "hand.draw")
                                .resizable()
                                .symbolRenderingMode(.hierarchical)
                                .frame(width: 20, height: 20)
                            Text("모션")
                                .font(NanumFont.buttonLabel)
                                .lineLimit(1)
                        }
                    }
                    .frame(height: 50)
                    .foregroundColor(Color.white)
                    .buttonStyle(BorderedButtonStyle(tint: Color.black))
                    
                    Button(action: {
                        withAnimation {
                            // action
                        }
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "waveform.and.mic")
                                .resizable()
                                .symbolRenderingMode(.hierarchical)
                                .frame(width: 20, height: 20)
                            Text("소리")
                                .font(NanumFont.buttonLabel)
                                .lineLimit(1)
                        }
                    }
                    .frame(height: 50)
                    .foregroundColor(Color.white)
                    .buttonStyle(BorderedButtonStyle(tint: Color.black))
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
                
                
                //                targetLabel()
                //                if viewModel.isGoalReached {
                //                    resetButton()
                //                } else {
                //                    DrinkButton(text: viewModel.drinkText, action: viewModel.didTapDrink)
                //                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
        }
    }
}

struct WavePaceView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(300.0) {
            WavePaceView(targetNumberOfGlasses: 10, selectedDrinkType: drinks[2], currentDrinkAmount: $0)
            
        }
    }
}
