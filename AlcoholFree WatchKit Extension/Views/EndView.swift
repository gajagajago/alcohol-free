//
//  EndView.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 유준열 on 2021/10/14.
//

import SwiftUI

struct EndView: View {
    @Binding var timerConnected: Bool
    
    var body: some View {
        NavigationLink(destination: SummaryView().navigationBarBackButtonHidden(true)){
            ZStack {
                Circle()
                    .frame(width: 100.0, height: 100.0)
                    .foregroundColor(.blue)
                Text("종료")
            }
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 150.0)
        .navigationBarBackButtonHidden(true)
        .simultaneousGesture(TapGesture().onEnded {
            timerConnected = false
        })
    }
}

struct EndView_Previews: PreviewProvider {
    static var previews: some View {
        EndView(timerConnected: .constant(false))
    }
}
