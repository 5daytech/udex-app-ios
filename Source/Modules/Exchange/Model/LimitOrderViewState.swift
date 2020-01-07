import Foundation

struct LimitOrderViewState: IExchangeViewState {
  var sendAmount: Decimal
  var sendCoin: ExchangeCoinViewItem?
  var receiveCoin: ExchangeCoinViewItem?
}
