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
    let chartStyle = ChartStyle(
        backgroundColor: Color.white,
        accentColor: Colors.OrangeStart,
        secondGradientColor: Colors.OrangeEnd,
        textColor: Color.white,
        legendTextColor: Color.white,
        dropShadowColor: Color.black)

    var body: some View {
        BarChartView(
            data: ChartData(points: globalViewModel.minutelyPaces),
            title: "페이스",
            style: Styles.barChartMidnightGreenDark,
            dropShadow: false)
    }
}

struct PaceGraphView_Previews: PreviewProvider {
    static var previews: some View {
        PaceGraphView().environmentObject(GlobalDrinkViewModel())
    }
}
