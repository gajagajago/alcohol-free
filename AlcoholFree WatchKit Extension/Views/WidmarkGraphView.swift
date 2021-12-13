import SwiftUI
import SwiftUICharts

struct WidmarkGraphView: View {
    @EnvironmentObject var globalViewModel: GlobalDrinkViewModel
    
    var body: some View {
        LineChartView(dataPoints: globalViewModel.concentrationDataPoints)
            .chartStyle(LineChartStyle(showAxis: false, showLabels: false, showLegends: false))
            .padding(.horizontal, 15)
            .padding(.top, 15)
            .padding(.bottom, 15)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0)
    }
}

struct WidmarkGraphView_Previews: PreviewProvider {
    static var previews: some View {
        WidmarkGraphView().environmentObject(GlobalDrinkViewModel(targetNumberOfGlasses: 20))
    }
}
