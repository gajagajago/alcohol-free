//
//  SetDrinkView.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 유준열 on 2021/11/06.
//

import SwiftUI

struct SetDrinkView: View {
    var selectedPace: Int
    @State var selectedDrink = drinks[0]
    
    var body: some View {
        VStack {
            HStack {
                Text("주종을 설정해주세요")
                    .multilineTextAlignment(.center)
                    .padding()
                    .font(.title3.weight(.semibold))
                    .fixedSize(horizontal: false, vertical: true)
            }
            HStack(alignment: .bottom) {
                Picker(selection: $selectedDrink, label: Text("Select drink")){
                    ForEach(drinks, id: \.self) { drink in
                        Text(drink.name)
                            .font(.title3)
                    }
                }
                .frame(height: 40.0)
                .labelsHidden()
                .pickerStyle(WheelPickerStyle())
            }
            Spacer()
            NavigationLink(
                destination: DetailView(
                    selectedPace: selectedPace,
                    selectedDrink: selectedDrink
                ).navigationBarBackButtonHidden(true)){
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 150.0, height: 45.0)
                        .foregroundColor(.blue)
                    Text("시작")
                }
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: 150.0)
            .navigationBarBackButtonHidden(true)
            .simultaneousGesture(TapGesture().onEnded {
                LocalNotificationManager().addNormalNoti(title: "술 마시는 손에 워치를 착용해주세요")
            })
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct SetDrinkView_Previews: PreviewProvider {
    static var previews: some View {
        SetDrinkView(selectedPace: 1)
    }
}
