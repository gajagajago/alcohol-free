//
//  DetailView.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 유준열 on 2021/10/14.
//

import SwiftUI

struct DetailView: View {
    var drinkClassifierManager = DrinkClassifierManager()
    var body: some View {
        TabView {
            PaceView()
            EndView()
        }.onAppear {
            drinkClassifierManager.startMotionUpdates()
        }.onDisappear {
            print("ON DISAPPEAR")
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
