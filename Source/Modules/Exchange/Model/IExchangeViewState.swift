import Foundation

protocol IExchangeViewState {
  var sendAmount: Decimal { get set }
  var sendCoin: ExchangeCoinViewItem? { get set }
  var receiveCoin: ExchangeCoinViewItem? { get set }
}
