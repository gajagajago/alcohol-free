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
        MultiLineChartView(data: [(globalViewModel.minutelyPaces, GradientColors.purple)], title: "페이스")

    }
}

struct PaceGraphView_Previews: PreviewProvider {
    static var previews: some View {
        PaceGraphView()
    }
}
