import SwiftUI

struct ExchangeNumberPad: View {
  
  var mainTitle: String
  var onNumberPressed: (String) -> Void
  var onMainPressed: () -> Void
  
  var body: some View {
    VStack(spacing: 30) {
      NumberPad { number in
        self.onNumberPressed(number)
      }
      Button(action: {
        self.onMainPressed()
      }) {
        Spacer()
        Text(mainTitle)
          .font(.system(size: 18, weight: .bold))
          .foregroundColor(Color("background"))
          .padding([.top, .bottom], 16)
        Spacer()
      }
      .background(Color("main"))
    }
  }
}

struct ExchangeNumberPad_Previews: PreviewProvider {
  static var previews: some View {
    ExchangeNumberPad(mainTitle: "EXCHANGE", onNumberPressed: { _ in }, onMainPressed: {})
  }
}
