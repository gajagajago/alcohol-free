//
//  DetailView.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 유준열 on 2021/10/14.
//

import SwiftUI

struct DetailView: View, ResultsDelegator {
    var selectedPace: Int
    @State var count = 0
    @State var currentPace = 0.0
    
    var body: some View {
        TabView {
            PaceView(selectedPace: selectedPace, currentPace: $currentPace)
            EndView()
        }
        .onAppear {
            SoundClassifier.shared.start(resultsObserver: ResultsObserver(delegator: self))
        }
    }
    
    func delegate(identifier: String, confidence: Double) {
        if (identifier == "glass_clink") {
            count += 1
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selectedPace: 0)
    }
}
