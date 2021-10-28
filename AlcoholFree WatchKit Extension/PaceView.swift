//
//  PaceView.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 유준열 on 2021/10/14.
//

import SwiftUI

struct PaceView: View {
    var selectedPace: Int
    @Binding var currentPace: Double
    var timerThreshold: Int // 초기 기준 시간
    
    var body: some View {
        
        VStack(alignment: .leading ) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("현재 페이스")
                        .font(.system(size: 15))
                    
                    HStack(alignment: .bottom) {
                        Text("\(currentPace * Double(timerThreshold), specifier: "%.1f")잔")
                            .font(.system(size: 30, weight: .semibold))
                        Text(" / 10분")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.gray)
                        
                    }
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("목표 페이스")
                        .font(.system(size: 15))
                    Text("\(selectedPace)잔")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(currentPace * Double(timerThreshold) > Double(selectedPace) ? Color.red : Color.green)
                        .frame(height:30)
                }
            }
            Spacer()
            VStack(alignment: .leading) {
                Text("추정 혈중 알코올 농도")
                    .font(.system(size: 15))
                
                Text("0.03%")
                    .font(.system(size: 30, weight: .semibold))
            }
            Spacer()
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PaceView_Previews: PreviewProvider {
    static var previews: some View {
        PaceView(selectedPace: 2, currentPace: .constant(0.3), timerThreshold: 10)
    }
}
