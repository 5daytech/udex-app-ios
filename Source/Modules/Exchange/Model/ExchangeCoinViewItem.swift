import Foundation

struct ExchangeCoinViewItem: Hashable {
  enum State {
    case down, up, none
  }
  
  let code: String
  let balance: Decimal
  var state: State
}
