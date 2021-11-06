//
//  SetPaceView.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 유준열 on 2021/11/06.
//

import SwiftUI

struct SetPaceView: View {
    @State var selectedPace = 1

    var body: some View {
        VStack {
            HStack {
                Text("목표 페이스를 설정해주세요")
                    .multilineTextAlignment(.center)
                    .padding()
                    .font(.title3.weight(.semibold))
                    .fixedSize(horizontal: false, vertical: true)
            }
            HStack(alignment: .bottom) {
                Picker(selection: $selectedPace, label: Text("Select pace")){
                    ForEach(1...10, id: \.self) {
                        Text("\($0)")
                            .font(.title3)
                    }
                }
                .frame(width: 80,height: 40.0)
                .labelsHidden()
                .pickerStyle(WheelPickerStyle())
                
                Text(" 잔 / 10분").font(.headline)
            }
            Spacer()
            NavigationLink(destination: SetDrinkView(selectedPace: selectedPace)
                            .navigationBarBackButtonHidden(true)){
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 150.0, height: 45.0)
                        .foregroundColor(.blue)
                    Text("다음")
                }
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: 150.0)
            .navigationBarBackButtonHidden(true)
        }
        .ignoresSafeArea(edges: .bottom)    }
}

struct SetPaceView_Previews: PreviewProvider {
    static var previews: some View {
        SetPaceView()
    }
}
