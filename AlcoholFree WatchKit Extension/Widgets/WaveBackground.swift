//
//  WaveV2.swift.swift
//  AlcoholFree WatchKit Extension
//
//  Created by 박신홍 on 2021/11/19.
//

import SwiftUI


struct WaveBackground<Content: View>: View {
    private let content: Content
    @State private var waveOffset = Angle(degrees: 0)
    @State private var waveOffset2 = Angle(degrees: 0)
    let percent: Double
    let waveColor: Color = Color(red: 0, green: 0.8, blue: 1)
    
    init(percent: Double = 0, @ViewBuilder content: () -> Content) {
        self.percent = percent
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                ZStack {
                    Text("\(self.percent)%")
                        .foregroundColor(.black)
                        .font(Font.system(size: 0.25 * min(geo.size.width, geo.size.height) ))
                    Wave(offset: Angle(degrees: self.waveOffset.degrees), percent: percent)
                        .fill(waveColor)
                        .onAppear {
                            withAnimation(Animation.linear(duration: 5).repeatForever(autoreverses: false)) {
                                self.waveOffset = Angle(degrees: 360)
                            }
                        }
                    Wave(offset: Angle(degrees: self.waveOffset2.degrees - 120), percent: percent)
                        .fill(waveColor)
                        .opacity(0.5)
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                                self.waveOffset2 = Angle(degrees: 360)
                            }
                        }
                }
                
            }
            .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            
            content
        }
    }
}

struct ContentView_Previews2: PreviewProvider {
    static var previews: some View {
        WaveBackground(percent: 0.71) {
            Text("Hey")
        }
    }
}
