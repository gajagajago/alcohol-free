//
//  ContentView.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 유준열 on 2021/09/30.
//

import SwiftUI

struct ContentView: View {
    @State var selectedPace = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Text("목표 페이스를 설정해주세요.")
                    .padding()
                
                HStack(alignment: .bottom) {
                    Picker(selection: $selectedPace, label: Text("Select pace")){
                        ForEach(1...10, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .frame(width: 80.0, height: 40.0)
                    .labelsHidden()
                    .pickerStyle(WheelPickerStyle())
                    
                    Text("잔 / 10분")
                }
                .padding()
                
                NavigationLink(destination: DetailView()
                                .navigationBarBackButtonHidden(true)){
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 150.0, height: 45.0)
                            .foregroundColor(.blue)
                        Text("시작")
                    }
                    .padding()
                }
                .buttonStyle(PlainButtonStyle())
                .frame(width: 150.0)
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
