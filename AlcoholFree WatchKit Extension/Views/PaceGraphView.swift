//
//  PaceGraphView.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 유준열 on 2021/11/27.
//

import SwiftUI
import SwiftUICharts

struct PaceGraphView: View {
    @EnvironmentObject var globalViewModel: GlobalDrinkViewModel
    
    var body: some View {
        BarChartView(dataPoints: globalViewModel.drinkHistoryDataPoints, limit: globalViewModel.averagePaceDataPoint)
            .chartStyle(BarChartStyle(barMinHeight: 75, showAxis: false, showLabels: false, showLegends: false))
            .padding(.horizontal, 15)
            .padding(.vertical, 15)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0)
    }
}

struct PaceGraphView_Previews: PreviewProvider {
    static var previews: some View {
        PaceGraphView().environmentObject(GlobalDrinkViewModel(targetNumberOfGlasses: 20))
    }
}
