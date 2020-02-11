import Foundation

struct ExchangeCoinViewItem: Hashable {
  enum State {
    case down, up, none
  }
  
  let coin: Coin
  let balance: Decimal
  var state: State
}
