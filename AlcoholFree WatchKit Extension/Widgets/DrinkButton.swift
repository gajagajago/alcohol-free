import SwiftUI

struct DrinkButton: View {
    var text: String
    let iconName: String
    var action: () -> Void
    var body: some View {
        Button(action: {
            withAnimation { self.action() }
        }) {
            HStack(spacing: 5) {
                Image(systemName: iconName)
                .resizable()
                .symbolRenderingMode(.hierarchical)
                .frame(width: 20, height: 20)
                Text(text)
                    .font(NanumFont.buttonLabel)
                    .lineLimit(1)
            }
        }
        .padding(.bottom, 5)
        .foregroundColor(Color.white)
        .buttonStyle(BorderedButtonStyle(tint: Color.black))
        .buttonBorderShape(ButtonBorderShape.capsule)
        
    }
}

struct DrinkButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            DrinkButton(text: "모션", iconName: "hand.draw") { }
            DrinkButton(text: "소리", iconName: "waveform.and.mic") { }
        }
        .padding(.horizontal, 10)
        .background(Color.blue)
    }
}
