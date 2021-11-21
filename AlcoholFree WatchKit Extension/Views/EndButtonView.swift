//
//  EndView.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 박신홍 on 2021/11/19.
//

import SwiftUI

struct EndButtonView: View {
    @EnvironmentObject var globalViewModel: GlobalDrinkViewModel
    @State var isAlertPresented = false
    
    var body: some View {
        DrinkButton(text: "종료", iconName: "stop.circle") {
            isAlertPresented = true
//            globalViewModel.stopDrinkClassification()
//            globalViewModel.showChildNavigationViews = false
//            globalViewModel.resetToInitialState()
            
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 5)
        .alert(
            "모니터링을 종료하시겠습니까?", isPresented: $isAlertPresented, presenting: false
        ) { detail in
            Button(role: .destructive) {
                globalViewModel.stopDrinkClassification()
                globalViewModel.showChildNavigationViews = false
                globalViewModel.resetToInitialState()
            } label: {
                Text("종료")
            }
            Button("취소") {}
        } message: { detail in
            Text("지금까지의 기록이 사라지고 초기 상태로 되돌아갑니다.")
        }
    }
}

struct EndView_Previews: PreviewProvider {
    static var previews: some View {
        EndButtonView().background(Color.blue)
    }
}
