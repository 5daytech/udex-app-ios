import SwiftUI

struct OrderBookRow: View {
  let order: SimpleOrder
  
  var body: some View {
    GeometryReader { geometry in
      HStack {
        VStack(alignment: .leading) {
          Text(self.order.side == .BUY ? self.order.remainingTakerAmount.toDisplayFormat() : self.order.remainingMakerAmount.toDisplayFormat())
          .font(.system(size: 12))
          .foregroundColor(self.order.side == .BUY ? Color.green : Color.red)
          Text("~ $\(self.order.side == .BUY ? self.order.takerFiatAmount.toDisplayFormat() : self.order.makerFiatAmount.toDisplayFormat())")
          .font(.system(size: 8))
          .foregroundColor(Color("T2"))
        }
        .frame(width: (geometry.size.width / 2) - 20, alignment: .leading)
        Spacer()
        Text("for")
        .font(.system(size: 8))
        .foregroundColor(Color("T2"))
        Spacer()
        VStack(alignment: .trailing) {
          Text(self.order.side == .SELL ? self.order.remainingTakerAmount.toDisplayFormat() : self.order.remainingMakerAmount.toDisplayFormat())
          .font(.system(size: 12))
          Text("~ $\(self.order.side == .SELL ? self.order.takerFiatAmount.toDisplayFormat() : self.order.makerFiatAmount.toDisplayFormat())")
          .font(.system(size: 8))
          .foregroundColor(Color("T2"))
        }
        .frame(width: (geometry.size.width / 2) - 20, alignment: .trailing)
      }
    }
  }
}
