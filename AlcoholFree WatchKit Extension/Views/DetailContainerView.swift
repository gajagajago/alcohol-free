//
//  DetailContainerView.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 박신홍 on 2021/11/19.
//

import SwiftUI


struct DetailContainerView: View {
    @EnvironmentObject var globalViewModel: GlobalDrinkViewModel
    
    var body: some View {
        WaveBackground(percent: globalViewModel.wavePercentage) {
            ScrollView {
                PaceView().frame(height: 170)
                EndButtonView()
            }
        }
    }
}

struct DetailContainerView_Previews: PreviewProvider {
    static var previews: some View {
        DetailContainerView().environmentObject(GlobalDrinkViewModel(targetNumberOfGlasses: 20))
    }
}
