import Foundation

struct MarketOrderViewState {
  var sendAmount: Decimal
  var sendCoin: ExchangeCoinViewItem?
  var receiveCoin: ExchangeCoinViewItem?
  var receiveAmount: Decimal
}
