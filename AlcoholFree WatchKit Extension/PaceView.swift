//
//  PaceView.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 유준열 on 2021/10/14.
//

import SwiftUI

struct PaceView: View {
    @Binding var count: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("현재 페이스")
                    .font(.system(size: 15))
                
                HStack(alignment: .bottom) {
                    Text("\(count)잔")
                        .font(.system(size: 30, weight: .semibold))
                    
                    Text(" / 10분")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 10.0)

            
            VStack(alignment: .leading) {
                Text("추정 혈중 알코올 농도")
                    .frame(height: 15)
                
                Text("0.03%")
                    .font(.system(size: 30, weight: .semibold))
            }
            
            Spacer()
        }
    }
}

struct PaceView_Previews: PreviewProvider {
    static var previews: some View {
        PaceView(count: .constant(0))
    }
}
