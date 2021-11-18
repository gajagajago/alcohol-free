//
//  SetTargetView.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 박신홍 on 2021/11/19.
//

import SwiftUI

struct SetDrinkTypeView: View {
    @State var selectedDrinkType = drinks[2]
    var body: some View {
        VStack {
            Text("오늘은 어떤 술로 달리시나요?")
                .multilineTextAlignment(.center)
                .font(NanumFont.title)
                .lineSpacing(2)
            
            Spacer()
            
            Picker(selection: $selectedDrinkType, label: Text("Select drink")){
                ForEach(drinks, id: \.self) { drink in
                    Text(drink.name)
                        .font(Font.custom(NanumFontNames.extraBold.rawValue, size: 17))
                }
            }
            .frame(height: 70.0)
            .labelsHidden()
            .pickerStyle(WheelPickerStyle())
            
            Spacer()
            
            NavigationLink(destination: SetTargetAmoutView(selectedDrinkType: selectedDrinkType, numberOfGlasses: 1)) {
                Text("다음")
                    .font(NanumFont.buttonLabel)
            }
            .padding(.horizontal, 20)
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

struct SetTargetView_Previews: PreviewProvider {
    static var previews: some View {
        SetDrinkTypeView()
    }
}

