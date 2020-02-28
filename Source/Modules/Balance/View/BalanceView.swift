import SwiftUI

struct BalanceView: View {  
  @State public var showRefreshView: Bool = false
  @State public var pullStatus: CGFloat = 0
  
  @State var isTransactionDest = false
  
  @State var coin = App.instance.coinManager.getCoin(code: "WETH")
  
  var onWrap: () -> Void
  var onUnwrap: () -> Void
  var onSend: (Coin) -> Void
  var onReceive: (Coin) -> Void
  
  var body: some View {
    BalanceViewWrapper(
      onWrap: {
        self.onWrap()
      },
      onUnwrap: {
        self.onUnwrap()
      },
      onSend: { coin in
        self.onSend(coin)
      },
      onReceive: { coin in
        self.onReceive(coin)
      },
      onTransactions: { coin in
        self.coin = coin
        self.isTransactionDest = true
      }
    ).sheet(isPresented: $isTransactionDest) {
      TransactionsView(viewModel: TransactionsViewModel(coin: self.coin))
    }
  }
}
