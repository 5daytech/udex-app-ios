import SwiftUI

struct ExchangeInputView: View {
  var text: String?
  let onTap: () -> Void
  var isPipeShowing: Bool
  let receiveAmount: String?
  let errorMessage: String?
  let fiatAmount: String?
  let availableAmount: String?
  
  @State var dim = false
  var body: some View {
    VStack(alignment: .leading) {
      if errorMessage != nil {
        Text("\(errorMessage!)")
          .font(.system(size: 12))
          .foregroundColor(Color.red)
      } else if fiatAmount != nil {
        Text("~$\(fiatAmount!)")
          .font(.system(size: 12))
          .foregroundColor(Color("T2"))
      }
      HStack {
        Text(text ?? (isPipeShowing ? "" : "0.00"))
          .lineLimit(1)
        if isPipeShowing {
          Text("|")
            .offset(x: -9)
            .opacity(dim ? 0 : 1.0)
            .animation(
              Animation
                .linear(duration: 0.5)
                .repeatForever()
          )
            .onAppear {
              self.dim.toggle()
          }
        }
      }
      if receiveAmount != nil {
        Text("You receive: \(receiveAmount!)")
          .font(.system(size: 14, weight: .bold))
          .foregroundColor(Color("T1"))
      } else if availableAmount != nil {
        Text("Available: \(availableAmount!)")
          .font(.system(size: 12))
          .foregroundColor(Color.orange)
      }
    }
    .onTapGesture {
      self.onTap()
    }
  }
}
