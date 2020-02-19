import Foundation

struct TotalBalanceInfo {
  let coin: Coin
  var balance: Decimal
  var fiatBalance: Decimal
  
  var balanceStr: String {
    "~\(balance.toDisplayFormat()) \(coin.code)"
  }
  
  var fiatBalanceStr: String {
    "$\(fiatBalance.toDisplayFormat(2))"
  }
}
