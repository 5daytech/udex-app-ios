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
          .font(.custom(Constants.Fonts.regular, size: 10))
          .foregroundColor(Color.red)
      } else if fiatAmount != nil {
        Text("~$\(fiatAmount!)")
          .font(.custom(Constants.Fonts.regular, size: 10))
          .foregroundColor(Color("T2"))
      }
      PipeInputView(isPipeShowing: isPipeShowing, text: text)
      if receiveAmount != nil {
        Text("You receive: \(receiveAmount!)")
          .font(.custom(Constants.Fonts.regular, size: 10))
          .foregroundColor(Color("T1"))
      } else if availableAmount != nil {
        Text("Available: \(availableAmount!)")
          .font(.custom(Constants.Fonts.regular, size: 10))
          .foregroundColor(Color.orange)
      }
    }
    .onTapGesture {
      self.onTap()
    }
  }
}
