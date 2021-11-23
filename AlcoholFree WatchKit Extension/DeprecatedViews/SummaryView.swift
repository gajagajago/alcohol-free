//
//  SummaryView.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 유준열 on 2021/10/14.
//

import SwiftUI

struct SummaryView: View {
    var body: some View {
        VStack {
            Text("Summary")
            
            NavigationLink(destination: ContentView()
                            .navigationBarBackButtonHidden(true)){
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 150.0, height: 45.0)
                        .foregroundColor(.blue)
                    Text("메인으로 돌아가기")
                }
                .padding()
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: 150.0)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}
