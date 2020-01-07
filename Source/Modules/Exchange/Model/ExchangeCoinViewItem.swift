import Foundation

struct ExchangeCoinViewItem {
  let code: String
  let balance: Decimal
  
  var balanceStr: String {
    return "\(balance)"
  }
}
