//
//  EndView.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 박신홍 on 2021/11/19.
//

import SwiftUI

struct EndView: View {
    var body: some View {
        NavigationLink(destination: EndView()){
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
    }
}

struct EndView_Previews: PreviewProvider {
    static var previews: some View {
        EndView()
    }
}
