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
            GeometryReader { proxy in
                ScrollView {
                    VStack(spacing: 0) {
                        PaceView().frame(height: proxy.size.height)
                        EndButtonView()
                    }
                }
            }.ignoresSafeArea()
            
        }
    }
}

struct DetailContainerView_Previews: PreviewProvider {
    static var previews: some View {
        DetailContainerView().environmentObject(GlobalDrinkViewModel(targetNumberOfGlasses: 20))
    }
}
