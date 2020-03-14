import SwiftUI

struct BalanceView: View {  
  @State public var showRefreshView: Bool = false
  @State public var pullStatus: CGFloat = 0
  
  @State var activeSheet = ""
  @State var showSheet = false
  
  @State var coin: Coin?
  
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
        self.showSheet = true
        self.activeSheet = "transactions"
      },
      onOpenCoinManager: {
        self.showSheet = true
        self.activeSheet = "coin_manager"
      }
    ).sheet(isPresented: $showSheet) {
      if self.activeSheet == "transactions" {
        TransactionsView(viewModel: TransactionsViewModel(coin: self.coin ?? App.instance.coinManager.getCoin(code: "WETH")))
      } else if self.activeSheet == "coin_manager" {
        CoinManagerView()
      }
    }
  }
}
