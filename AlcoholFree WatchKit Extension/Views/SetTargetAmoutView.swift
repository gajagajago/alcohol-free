//
//  SetTargetAmoutView.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 박신홍 on 2021/11/19.
//

import SwiftUI

struct SetTargetAmoutView: View {
    @EnvironmentObject var globalViewModel: GlobalDrinkViewModel
    
    var body: some View {
        VStack {
            Text("오늘의 목표는 몇 잔인가요?")
                .multilineTextAlignment(.center)
                .font(NanumFont.title)
                .lineSpacing(2)
            
            Spacer()
            
            Text(globalViewModel.targetNumberOfGlassesAsString)
                .font(Font.custom(NanumFontNames.extraBold.rawValue, size: 28))
                .foregroundColor(.init(red: 0, green: 0.8, blue: 1))
            
            let needWarning = globalViewModel.needWarningForHighTarget
            HStack {
                if needWarning {
                    Text("⚠️").font(.system(size: 12))
                }
                Text("\(globalViewModel.targetNumberOfBottlesAsString)")
                    .font(Font.custom(NanumFontNames.bold.rawValue, size: 14))
                    .foregroundColor(.gray)
                    .padding(.top, 0.1)
            }
            .animation(.easeInOut(duration: 0.5), value: needWarning)
            
            Spacer()
            
            NavigationLink(destination: DetailContainerView()) {
                Text("시작")
                    .font(NanumFont.buttonLabel)
            }
            .padding(.horizontal, 20)
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .focusable()
        .digitalCrownRotation($globalViewModel.targetNumberOfGlasses, from: 1.0, through: 50.0, by: 1, sensitivity: .low)
    }
}

struct SetTargetAmoutView_Previews: PreviewProvider {
    static var previews: some View {
        SetTargetAmoutView()
    }
}
