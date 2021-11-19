//
//  ContentView.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 유준열 on 2021/09/30.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            SetDrinkTypeView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environmentObject(GlobalDrinkViewModel())
        }
    }
}
