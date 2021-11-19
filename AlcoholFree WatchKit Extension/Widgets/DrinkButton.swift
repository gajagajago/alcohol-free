import SwiftUI

struct DrinkButton: View {
    var text: String
    var action: () -> Void
    var body: some View {
        Button(action: {
            withAnimation { self.action() }
        }) {
            HStack(spacing: 5) {
                Image(systemName: "hand.draw")
                .resizable()
                .symbolRenderingMode(.hierarchical)
                .frame(width: 20, height: 20)
                Text(text)
                    .font(NanumFont.buttonLabel)
                    .lineLimit(1)
            }
        }
        .frame(height: 50)
        
    }
}

struct DrinkButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            DrinkButton(text: "모션") { }
            DrinkButton(text: "소리") { }
        }
        .padding(.horizontal, 10)
    }
}
