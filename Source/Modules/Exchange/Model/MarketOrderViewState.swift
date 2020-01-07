import Foundation

struct MarketOrderViewState: IExchangeViewState {
  var sendAmount: Decimal
  var sendCoin: ExchangeCoinViewItem?
  var receiveCoin: ExchangeCoinViewItem?
  var receiveAmount: Decimal
}
