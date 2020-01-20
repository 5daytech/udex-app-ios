import SwiftUI

struct ExchangeInputView: View {
  var text: String?
  let onTap: () -> Void
  var isPipeShowing: Bool
  let receiveAmount: String?
  
  @State var dim = false
  
    var body: some View {
      VStack(alignment: .leading) {
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
        }
      }
      
        .onTapGesture {
          self.onTap()
        }
    }
}
