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
        TabView {
            WavePaceView()
            EndView()
        }
        .onAppear {
            globalViewModel.startDrinkClassification()
        }
        .onDisappear {
            globalViewModel.stopDrinkClassification()
        }
    }
}

struct DetailContainerView_Previews: PreviewProvider {
    static var previews: some View {
        DetailContainerView()
    }
}
