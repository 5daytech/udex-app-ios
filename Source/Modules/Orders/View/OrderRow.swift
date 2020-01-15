import SwiftUI

struct OrderRow: View {
  var order: SimpleOrder
  
  var body: some View {
    GeometryReader { geometry in
      HStack {
        VStack(alignment: .leading) {
          HStack {
            Text(self.order.side == .BUY ? self.order.remainingTakerAmount.toDisplayFormat() : self.order.remainingMakerAmount.toDisplayFormat())
              .font(.system(size: 14))
            .foregroundColor(Color("T1"))
            Text(self.order.side == .BUY ? self.order.takerCoin.code : self.order.makerCoin.code)
              .font(.system(size: 14))
            .foregroundColor(Color("T3"))
          }
          Text("~ $\(self.order.side == .BUY ? self.order.takerFiatAmount.toDisplayFormat() : self.order.makerFiatAmount.toDisplayFormat())")
            .font(.system(size: 12))
          .foregroundColor(Color("T2"))
        }
        .frame(width: (geometry.size.width / 2) - 20, alignment: .leading)
        Spacer()
        Text("for")
        .font(.system(size: 8))
        .foregroundColor(Color("T2"))
        Spacer()
        VStack(alignment: .trailing) {
          HStack {
            Text(self.order.side == .SELL ? self.order.remainingTakerAmount.toDisplayFormat() : self.order.remainingMakerAmount.toDisplayFormat())
              .font(.system(size: 14))
              .foregroundColor(Color.green)
            Text(self.order.side == .SELL ? self.order.takerCoin.code : self.order.makerCoin.code)
              .font(.system(size: 14))
            .foregroundColor(Color("T3"))
          }
          Text("~ $\(self.order.side == .SELL ? self.order.takerFiatAmount.toDisplayFormat() : self.order.makerFiatAmount.toDisplayFormat())")
            .font(.system(size: 12))
          .foregroundColor(Color("T2"))
        }
        .frame(width: (geometry.size.width / 2) - 20, alignment: .trailing)
        
      }
    }
  }
}
