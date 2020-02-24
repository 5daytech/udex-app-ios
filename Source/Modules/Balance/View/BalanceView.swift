import SwiftUI

struct BalanceView: View {  
  @State public var showRefreshView: Bool = false
  @State public var pullStatus: CGFloat = 0
  
  var onWrap: () -> Void
  var onUnwrap: () -> Void
  var onSend: () -> Void
  var onReceive: (Coin) -> Void
  
  var body: some View {
    ZStack {
      BalanceViewWrapper(
        onWrap: {
          self.onWrap()
        },
        onUnwrap: {
          self.onUnwrap()
        },
        onSend: {
          self.onSend()
        },
        onReceive: { coin in
          self.onReceive(coin)
        },
        onTransactions: {
          
        }
      )
    }
  }
}
